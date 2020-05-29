//
//  LogViewController.swift
//  Benson
//
//  Created by Aaron Baw on 27/08/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit
import CareKit
import SwiftyJSON

/// Determines the values which should be displayed by the UIPickerView.
enum SelectionMode {
    case ChartMetric
    case TimeUnit
}

// Questions:
// - How to add pull to refresh with an action
// - How to add spacing between cells

class LogViewController: UIViewController{
       
    @IBOutlet weak var chartViewContainer: UIView!
    
    @IBOutlet weak var chartActivityIndicator: UIActivityIndicatorView! {
        didSet {
            self.chartActivityIndicator.hidesWhenStopped = true
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chartMetricSelectionButton: BensonButton!
    
    @IBOutlet weak var chartTimeUnitSelectionButton: BensonButton!
    
    // Stored and computed properties.
    var logs: [YPDCheckin] = [] {
        
        // This is run from whatever context actually set the variable. If we are updating the variable from a background thread, then the execution of this closure occur within that thread.
        didSet {
            tableView.reloadData()
        }
        
    }

    var selectedChartMetrics: [YPDCheckinType] = [.generalFeeling] {
        didSet {
            self.updateChartAndButtons()
        }
    }

    var selectedTimeUnit: AggregationCriteria = .day {
        didSet {
            self.updateChartAndButtons()
        }
    }
    
    var selectionMode: SelectionMode = .ChartMetric
    
    // Hold a copy of the fetcher in order to cache any metric logs.
    var fetcher: Fetcher = Fetcher()
    
    // Hold an instance of the picker view at the class level so that we hold a strong reference to it, and as such it will not be lost due to ARC.
    var pickerView: UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }
    
    /// Dummy text field which will be used to display the picker view.
    var dummyTextField: UITextField = UITextField(frame: CGRect.zero)
    
    /// Available metricTypes which the user can select from and view.
    var metricTypes: [YPDCheckinType] = YPDCheckinType.allCases
    
    /// Available time units which the user can select from and view.
    var timeUnits: [AggregationCriteria] = AggregationCriteria.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetcher.fetchMetricLogs(completionHandler: { metricLogs in
            self.log("\(metricLogs)")
            self.logs = metricLogs
        })
        
        // Configure pull to refresh.
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.tintColor = Colour.primary
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        // Remove styling on the separator.
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        // Configure the chartMetricSelection and chartTimeUnitSelection buttons.
        self.updateChartAndButtons()
        
        self.chartMetricSelectionButton.addTarget(self, action: #selector(self.chartMetricSelectionHandler), for: .touchUpInside)
        self.chartTimeUnitSelectionButton.addTarget(self, action: #selector(self.chartTimeUnitSelectionHandler), for: .touchUpInside)
        
        // Add a sample ChartView which integrates with CareKit.
    }
    
    @objc private func chartMetricSelectionHandler(){
        self.selectionMode = .ChartMetric
        self.log("All cases for MetricType: \(YPDCheckinType.allCases)")
//        self.selectedChartMetric = MetricType.allCases[(MetricType.allCases.firstIndex(of: self.selectedChartMetric)! + 1) % MetricType.allCases.count]
        self.displayMetricPickerViewForChartMetrics()
    }
    
    @objc private func chartTimeUnitSelectionHandler(){
        self.selectionMode = .TimeUnit
        self.displayMetricPickerViewForTimeUnits()
    }
    
    private func updateChartAndButtons(){
        self.chartActivityIndicator.startAnimating()
        chartMetricSelectionButton.setTitle(self.selectedChartMetrics.map { "\($0)" }.joined(separator: ", "), for: .normal)
        chartTimeUnitSelectionButton.setTitle("\(self.selectedTimeUnit)", for: .normal)
        Fetcher.sharedInstance.fetchAggregatedHealthAndCheckinData(byAggregationCriteria: self.selectedTimeUnit) { (data) in
            self.configureChartOverview(forData: data["result"], andAttributes: self.selectedChartMetrics.map { "\($0)" } , andSelectedTimeUnit: self.selectedTimeUnit)
            self.chartActivityIndicator.stopAnimating()
            
        }
    }
    
    @objc private func reloadData(){
        self.log("Reloading metric logs and chart.")
        fetcher.fetchMetricLogs(completionHandler: { metricLogs in
            self.logs = metricLogs
            self.log("Refreshed metric logs.")
            self.tableView.refreshControl?.endRefreshing()
        })
        self.updateChartAndButtons()
    }
    
    private func log(_ message: String) {
         print("[LogViewController] | \(message)")
     }
    
}

// Handle metric and time unit selection.
extension LogViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    /// Alters the number of comparators depedending on whether '+' or '-' was tapped by the user in the UIToolbar attached to the pickerview.
    @objc private func changeComparatorValueHandler(withSender sender: Any?){
        if let barButton = sender as? UIBarButtonItem {
            if barButton.title == "+" {
                self.selectedChartMetrics.append(.generalFeeling)
            } else if barButton.title == "-" {
                self.selectedChartMetrics.removeLast()
            }
            (self.dummyTextField.inputView as? UIPickerView)?.reloadAllComponents()
            self.log("Comparators: \(self.selectedChartMetrics.count)")
        }
    }
    
    private func displayMetricPickerViewForChartMetrics(){

        dummyTextField = UITextField(frame: CGRect.zero)
        self.view.addSubview(dummyTextField)
        
        // Create a Toolbar with a 'done' button to resign the picker once completed.
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.pickerViewDoneHandler))
        
        let spacerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let incComparatorButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(self.changeComparatorValueHandler(withSender:)))
        
        let decComparatorButton = UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(self.changeComparatorValueHandler(withSender:)))
        
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        toolbar.setItems([incComparatorButton, decComparatorButton,     spacerButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        
        
        dummyTextField.inputAccessoryView = toolbar
        dummyTextField.inputView = self.pickerView
        dummyTextField.becomeFirstResponder()
    }
    
    private func displayMetricPickerViewForTimeUnits(){
        dummyTextField = UITextField(frame: CGRect.zero)
         self.view.addSubview(dummyTextField)
        
        let spacerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         
         // Create a Toolbar with a 'done' button to resign the picker once completed.
         let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.pickerViewDoneHandler))
         
         let toolbar = UIToolbar()
         toolbar.barStyle = .default
         toolbar.sizeToFit()
         toolbar.setItems([spacerButton, doneButton], animated: true)
         toolbar.isUserInteractionEnabled = true
        
         dummyTextField.inputAccessoryView = toolbar
         dummyTextField.inputView = self.pickerView
         dummyTextField.becomeFirstResponder()
    }
    
    /// Called when the user taps on the 'done' button after selecting the apprpriate metric type.
    @objc private func pickerViewDoneHandler(){
        self.dummyTextField.resignFirstResponder()
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.selectionMode == .ChartMetric ? self.selectedChartMetrics.count : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.selectionMode == .ChartMetric ? self.metricTypes.count : self.timeUnits.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.selectionMode == SelectionMode.ChartMetric ? "\(self.metricTypes[row])" : "\(self.timeUnits[row])"
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // When a row is selcted, ensure that we add to the list of selected metrics.
        switch self.selectionMode {
        case .ChartMetric:
            self.selectedChartMetrics[component] = self.metricTypes[row]
        case .TimeUnit:
            self.selectedTimeUnit = self.timeUnits[row]
        }
        
    }
    
}

// Picker view support.
extension LogViewController: UITableViewDelegate, UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Use twice as many cells in order to account for the separators in between each cell.
            return self.logs.count * 2
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if indexPath.row % 2 != 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellSeparator")!
                cell.selectionStyle = .none
                
                return cell
                
            } else {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "MetricLogCell")! as! CheckinCollectionViewCell
                cell.metricLog = self.logs[indexPath.row / 2]
                
                return cell
                
            }
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Only allow editing of rows which are divisble by two (logs).
            return indexPath.row % 2 == 0
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                fetcher.remove(metricLogId: self.logs[indexPath.row / 2].type ?? "") {
    //                tableView.deleteRows(at: [indexPath, IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .automatic)
                    // Checkpoint: Trying to understand why I can't add in the delete swipe animation.
                    self.logs.remove(at: indexPath.row / 2)
                    tableView.reloadData()
                }
            }
        }
    
}

/// Extend the LogViewController to support displaying the aggregated health and checkin data via CareKit charts.
extension LogViewController {
   
    /// Given  some JSON data representing the aggregated heath data, the selected attributes, and the TimeUnit, instantiates the chart view, if this has not already been done so, and updates the view to display the data.
    private func configureChartOverview(forData data: JSON, andAttributes attributes: [String], andSelectedTimeUnit timeUnit: AggregationCriteria) {
        
        let chartView = OCKCartesianChartView(type: .line)
        
        let chartData = YPDChartData.init(data: data, attributes: attributes, selectedTimeUnit: timeUnit)
                
        chartView.graphView.dataSeries = chartData.dataSeries
        //chartView.graphView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        //chartView.graphView.frame = chartViewContainer.bounds
        
        chartView.headerView.removeFromSuperview()
        self.log("Stack view items for OCKCartesianGraphView: \(chartView.contentStackView.arrangedSubviews)")
        
       // Remove unwanted header view from the ChartView's stack view.
        chartView.contentStackView.arrangedSubviews.first?.removeFromSuperview()
        
        chartView.graphView.horizontalAxisMarkers = chartData.horizontalAxisChartMarkers.sample(withAroundNumberOfPoints: 5)
        
        chartView.backgroundColor = Colour.secondary
                
        chartView.frame = self.chartViewContainer.bounds
                
        //chartView.headerView.titleLabel.text = "My Sample Chart"
        chartView.headerView.isHidden = true
        
        // Re-instantiate the chart view as a subview of the container.
        self.chartViewContainer.subviews.forEach { $0.removeFromSuperview() }
        
        self.chartViewContainer.addSubview(chartView)
        
    }
    
}
