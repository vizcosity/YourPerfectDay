//
//  LogViewController.swift
//  Benson
//
//  Created by Aaron Baw on 27/08/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit
import SwiftCharts
import SwiftyJSON

// Questions:
// - How to add pull to refresh with an action
// - How to add spacing between cells

class LogViewController: UIViewController{
    
    private var chart: Chart?
   
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
    var logs: [MetricLog] = [] {
        
        // This is run from whatever context actually set the variable. If we are updating the variable from a background thread, then the execution of this closure occur within that thread.
        didSet {
            tableView.reloadData()
        }
        
    }

    var selectedChartMetrics: [MetricType] = [.generalFeeling] {
        didSet {
            self.updateChartAndButtons()
        }
    }

    var selectedTimeUnit: AggregationCriteria = .day {
        didSet {
            self.updateChartAndButtons()
        }
    }
    
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
    var metricTypes: [MetricType] = MetricType.allCases
    
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
        refreshControl.addTarget(self, action: #selector(reloadMetricLogs), for: .valueChanged)
        
        // Remove styling on the separator.
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        // Configure the chartMetricSelection and chartTimeUnitSelection buttons.
        self.updateChartAndButtons()
        
        self.chartMetricSelectionButton.addTarget(self, action: #selector(self.chartMetricSelectionHandler), for: .touchUpInside)
        self.chartTimeUnitSelectionButton.addTarget(self, action: #selector(self.chartTimeUnitSelectionHandler), for: .touchUpInside)
//        self.present(self.pickerViewController, animated: true, completion: nil)
        
        // Hold the pickerView inside the view controller.
//        pickerViewController.view.addSubview(self.pickerView)
//        self.pickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        self.pickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.pickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        // TEMP: Attempt to add picker view as input view of input text field.
    }
    
    @objc private func chartMetricSelectionHandler(){
        self.log("All cases for MetricType: \(MetricType.allCases)")
//        self.selectedChartMetric = MetricType.allCases[(MetricType.allCases.firstIndex(of: self.selectedChartMetric)! + 1) % MetricType.allCases.count]
        self.displayMetricPickerView()
    }
    
    @objc private func chartTimeUnitSelectionHandler(){
        self.selectedTimeUnit = AggregationCriteria.allCases[(AggregationCriteria.allCases.firstIndex(of: self.selectedTimeUnit)! + 1) % AggregationCriteria.allCases.count]
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
    
    @objc private func reloadMetricLogs(){
        self.log("Reloading metric logs.")
        fetcher.fetchMetricLogs(completionHandler: { metricLogs in
            self.logs = metricLogs
            self.log("Refreshed metric logs.")
            self.tableView.refreshControl?.endRefreshing()
        })
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
    
    private func displayMetricPickerView(){

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
    
    /// Called when the user taps on the 'done' button after selecting the apprpriate metric type.
    @objc private func pickerViewDoneHandler(){
        self.dummyTextField.resignFirstResponder()
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.selectedChartMetrics.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.metricTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.metricTypes[row])"
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // When a row is selcted, ensure that we add to the list of selected metrics.
        self.selectedChartMetrics[component] = self.metricTypes[row]
    }
    
}

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
                fetcher.remove(metricLogId: self.logs[indexPath.row / 2].id ?? "") {
    //                tableView.deleteRows(at: [indexPath, IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .automatic)
                    // Checkpoint: Trying to understand why I can't add in the delete swipe animation.
                    self.logs.remove(at: indexPath.row / 2)
                    tableView.reloadData()
                }
            }
        }
    
}

// Checkpoint: Charting aggregated health and checkin data.
extension LogViewController {

    /// Generates a series of chart points for agiven attribute and array of aggregated health data & checkin objects.
    /// Parameters:
    /// - filterOutZeros: Filters out points which have a '0' value for the y axis. Useful for healthDataObjects where a '0' indicates the lack of a response.
    private func generateChartPoints(forAttribute attribute: String, andSelectedTimeUnit timeUnit: AggregationCriteria, ofAggregatedDataObjects data: [JSON], filterOutZeros: Bool = true) -> [ChartPoint] {
        let chartPoints = data.map { (item) -> ChartPoint in
            let formatter = ISO8601DateFormatter()
                          formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let parsedDate = formatter.date(from: item["startOfDate"].stringValue)
            let dateDay = parsedDate?.component(.day) ?? 0
            self.log("Mapping \(attribute) (\(item[attribute].stringValue)) of item: \(item) to a chartpoint.")
            return ChartPoint(x: ChartAxisValueInt(dateDay), y: ChartAxisValueDouble(Double(item[attribute].stringValue) ?? 0.0))
        }.filter { $0.y.scalar != 0 && filterOutZeros }
        self.log("Generated chart points: \(chartPoints)")
        return chartPoints
    }
    
    
    /// Returns ( (minX, minY), (maxX, maxY) ) for the chartPoints array passed.
    private func determineMaxAndMinAxisValues(forChartPointsArray chartPoints: [ChartPoint]) -> ((Double, Double), (Double, Double)) {
        
        guard chartPoints.count > 0 else { return ((0, 0), (0, 0)) }
        
        let firstItem = chartPoints.first!
        var ( (minX, minY), (maxX, maxY) ) = ((firstItem.x.scalar, firstItem.y.scalar), (firstItem.x.scalar, firstItem.y.scalar))
        
        chartPoints.forEach {
            minX = min($0.x.scalar, minX)
            minY = min($0.y.scalar, minY)
            maxX = max($0.x.scalar, maxX)
            maxY = max($0.y.scalar, maxY)
        }
        
        return ( (minX, minY), (maxX, maxY) )
        
    }
    
    /// Given a series of chart point arrays, determines both the max and minimum values for each axis, returning a tupe ( (minX, minY), (maxX, maxY) ) to be used to construct the appropriate labels for the chart.
    private func determineMaximumAxisValues(forArrayOfChartPointArrays chartPointArrays: [[ChartPoint]]) -> ((Double, Double), (Double, Double)) {
        
        var maxValues: [((Double, Double), (Double, Double))] = []
        
        chartPointArrays.forEach { maxValues.append(self.determineMaxAndMinAxisValues(forChartPointsArray: $0)) }
        
        var ( (minX, minY), (maxX, maxY) ) = maxValues.first!
        
        maxValues.forEach { item in
            let (((currMinX, currMinY), (currMaxX, currMaxY))) = item
            minX = min(minX, currMinX)
            minY = min(minY, currMinY)
            maxX = max(maxX, currMaxX)
            maxY = max(maxY, currMaxY)
        }
        
        return ( (minX, minY), (maxX, maxY) )
    }
    
    // Checkpoint: Dynamically adding an array of attributes to the chart, and ensuring that we fit the xAxis range to the largest and smallest value in the chartPoints array.
    private func configureChartOverview(forData data: JSON, andAttributes attributes: [String], andSelectedTimeUnit timeUnit: AggregationCriteria) {
                
        DispatchQueue.global(qos: .background).async {
            
            // Generate chart points for each of the attributes passed.
            var chartPointsForAttributes : [[ChartPoint]] = []
            attributes.forEach { chartPointsForAttributes.append(self.generateChartPoints(forAttribute: $0, andSelectedTimeUnit: timeUnit, ofAggregatedDataObjects: data.arrayValue)) }
            
            // For each set of chart points, determine the maximimum and minimum values for each axis, and then return the maximum of all of these.
            let ( (minX, minY), (maxX, maxY) ) = self.determineMaximumAxisValues(forArrayOfChartPointArrays: chartPointsForAttributes)
            
            self.log("Determined minimum and maximum axis values: \(( (minX, minY), (maxX, maxY) ))")
            
            let labelSettings = ChartLabelSettings(font: UIFont.preferredFont(forTextStyle: .footnote), fontColor: Colour.primary, rotation: 0, rotationKeep: .bottom, shiftXOnRotation: false, textAlignment: .default)
                    
            // We want at most 5  yTicks to represent all the values.
            // Ensure that the yAxisMultiplier is at least one.
            self.log("MinY: ")
            let yAxisGeneratorMultiplier = max(1, ((maxY - minY) / 5 ))
            let yGenerator = ChartAxisGeneratorMultiplier(yAxisGeneratorMultiplier)
            let labelsGenerator = ChartAxisLabelsGeneratorFunc {scalar in
                return ChartAxisLabel(text: "\(Int(scalar))", settings: labelSettings)
            }
            
            // We want at most 10 xTicks to represent all the values.
            let xAxisGeneratorMultiplier = round((maxX - minX) / 10 )
            let xGenerator = ChartAxisGeneratorMultiplier(xAxisGeneratorMultiplier)
            self.log("X Axis Generator Multiplier: \(xAxisGeneratorMultiplier). Y Axis Generator Multipler: \(yAxisGeneratorMultiplier)")
            
            let xModel = ChartAxisModel(lineColor: Colour.primary, firstModelValue: minX - 1, lastModelValue: maxX + 1, axisTitleLabels: [ChartAxisLabel(text: "\(timeUnit)", settings: labelSettings)], axisValuesGenerator: xGenerator, labelsGenerator: labelsGenerator)
                        
            let yModel = ChartAxisModel(lineColor: Colour.primary, firstModelValue: max(minY / 1.1, 0), lastModelValue: maxY * 1.1, axisTitleLabels: [ChartAxisLabel(text: attributes.joined(separator: ", "), settings: labelSettings.defaultVertical())], axisValuesGenerator: yGenerator, labelsGenerator: labelsGenerator)
            
            DispatchQueue.main.async {

                let chartFrame = self.chartViewContainer.bounds.insetBy(dx: 0, dy: 0)
                
                var chartSettings = ChartSettings()
                chartSettings.bottom = 10
                chartSettings.top = 25
                chartSettings.leading = 5
                chartSettings.trailing = 20
                chartSettings.labelsToAxisSpacingY = 10
                
                // generate axes layers and calculate chart inner frame, based on the axis models
                let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
                let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
                
                // create layer with guidelines
                let guidelinesLayerSettings = ChartGuideLinesDottedLayerSettings(linesColor: Colour.darkText, linesWidth: 1.0)
                let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: guidelinesLayerSettings)
                
                // view generator - this is a function that creates a view for each chartpoint
                let viewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsViewsLayer, chart: Chart) -> UIView? in
                    let viewSize: CGFloat = 5
                    let center = chartPointModel.screenLoc
                    let label = UILabel(frame: CGRect(x: center.x - viewSize / 2, y: center.y - viewSize / 2, width: viewSize, height: viewSize))
                    label.backgroundColor = Colour.secondary
                    label.textAlignment = NSTextAlignment.center
                    label.layer.cornerRadius = 100
                    label.font = UIFont.preferredFont(forTextStyle: .footnote)
                    label.textColor = UIColor.white
                    return label
                }
                
                var layers : [ChartLayer] = [
                    xAxisLayer,
                    yAxisLayer
                ]
                
                
                // Create a chartPointsLayer, a chartLineModel, and a chartPointsLineLayer, and add all of these to the layers array.
                for i in 0..<chartPointsForAttributes.count {
                    let chartPointsArray = chartPointsForAttributes[i]
                    // Create layer that uses viewGenerator to display chartpoints
                    // Ensure that we change the colour slightly for every layer that we add, to allow for better differentiation.
                    let chartPointsLayer = ChartPointsViewsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPointsArray, viewGenerator: viewGenerator, mode: .scaleAndTranslate)
                    let chartLineModel = ChartLineModel(chartPoints: chartPointsArray, lineColor: Colour.chartColours[i % Colour.chartColours.count], animDuration: 1.0, animDelay: 0)
                    let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [chartLineModel])
                    layers.append(chartPointsLayer)
                    layers.append(chartPointsLineLayer)
                    self.log("Appending \(chartPointsLineLayer) to chart.")
                }
                
                layers.append(guidelinesLayer)
                
                // create chart instance with frame and layers
                let chart = Chart(
                    frame: chartFrame,
                    innerFrame: innerFrame,
                    settings: chartSettings,
                    layers: layers
                )

                // Remove any existing charts from the contianer before adding this one.
                self.chartViewContainer.subviews.forEach { ($0 as? ChartView)?.removeFromSuperview() }
                self.chartViewContainer.addSubview(chart.view)
                self.chart = chart
                    
            }
            
        }
    }
    
}
