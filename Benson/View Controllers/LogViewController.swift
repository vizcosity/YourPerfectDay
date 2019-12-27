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
    
    @IBOutlet weak var tableView: UITableView!
    
    // Stored and computed properties.
    var logs: [MetricLog] = [] {
        
        // This is run from whatever context actually set the variable. If we are updating the variable from a background thread, then the execution of this closure occur within that thread.
        didSet {
            tableView.reloadData()
        }
        
    }
    
    // Hold a copy of the fetcher in order to cache any metric logs.
    var fetcher: Fetcher = Fetcher()
    
    
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
        
        Fetcher.sharedInstance.fetchAggregatedHealthAndCheckinData(byAggregationCriteria: .day) { (data) in
            self.configureChartOverview(forData: data, andAttributes: ["generalFeeling"])
        }
        
    }
    
    // Checkpoint: reloading metric logs is not synchronous, so the spinner continues indefinitely.
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
//    private func configureChartOverview(){
//        // Fetch the items from the backend.
//        Fetcher.sharedInstance.fetchAggregatedHealthAndCheckinData(byAggregationCriteria: .day, completionHandler: {
//            response in
//
//            // TEMP: Add in the chart view
//
//            let chartConfig = ChartConfigXY(
//                xAxisConfig: ChartAxisConfig(from: 2, to: 14, by: 2),
//                yAxisConfig: ChartAxisConfig(from: 0, to: 14, by: 2)
//            )
//
//            let frame = self.chartViewContainer.bounds.insetBy(dx: 30, dy: 30)
//
//            // Generate the chart points for a given attribute.
//            func generateChartPoints(forAttribute attribute: String, of data: [JSON]) -> [(Double, Double)] {
//                var index = -1;
//                return data.map { (item) -> (Double, Double) in
//                    index += 1
//                    return (Double(index), Double(item[attribute].stringValue) ?? 0.0)
//                }
//            }
//
//            let generalFeelingChartPoints = generateChartPoints(forAttribute: "generalFeeling", of: response["result"].arrayValue.map { $0["averageCheckin"] } )
//
//            self.log("Generated chart points for generalFeeling: \(generalFeelingChartPoints)")
//
//            // For each index, plot a new value.
//            let chart = LineChart(
//                frame: frame,
//                chartConfig: chartConfig,
//                xTitle: "Days",
//                yTitle: "Value",
//                lines: [
//                    (chartPoints: [(2.0, 10.6), (4.2, 5.1), (7.3, 3.0), (8.1, 5.5), (14.0, 8.0)], color: UIColor.white),
//                    (chartPoints: [(2.0, 2.6), (4.2, 4.1), (7.3, 1.0), (8.1, 11.5), (14.0, 3.0)], color: UIColor.systemPink),
//                    (chartPoints: generalFeelingChartPoints, color: UIColor.gray)
//                ]
//            )
//
//            let labelSettings = ChartLabelSettings(font: UIFont.preferredFont(forTextStyle: .body), fontColor: UIColor.white, rotation: 0, rotationKeep: .bottom, shiftXOnRotation: false, textAlignment: .default)
//
////            let otherChartConfig = ChartConfig(chartSettings: ChartSettings, guidelinesConfig: nil)
//
//            self.chartViewContainer.addSubview(chart.view)
//            self.chart = chart
//        })
//    }
    
    private func generateChartPoints(forAttribute attribute: String, ofAggregatedDataObjects data: [JSON]) -> [ChartPoint] {
        return data.map { (item) -> ChartPoint in
            let formatter = ISO8601DateFormatter()
                          formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let parsedDate = formatter.date(from: item["startOfDate"].stringValue)
            let dateDay = parsedDate?.component(.day) ?? 0
            self.log("Mapping \(attribute) (\(item[attribute].stringValue)) of item: \(item) to a chartpoint.")
            return ChartPoint(x: ChartAxisValueInt(dateDay), y: ChartAxisValueDouble(Double(item[attribute].stringValue) ?? 0.0))
        }
    }
    
    // Checkpoint: Dynamically adding an array of attributes to the chart, and ensuring that we fit the xAxis range to the largest and smallest value in the chartPoints array.
    private func configureChartOverview(forData data: JSON, andAttributes attributes: [String]) {
        
        // map model data to chart points
//        let chartPoints: [ChartPoint] = [(2, 2), (4, 8), (6, 4), (8, 2), (8, 10), (15, 15)].map{ChartPoint(x: ChartAxisValueInt($0.0), y: ChartAxisValueInt($0.1))}
        
        var chartPointsForAttributes : [[ChartPoint]] = []
        
        let generatedPoints = self.generateChartPoints(forAttribute: "generalFeeling", ofAggregatedDataObjects: data["result"].arrayValue)
        self.log("Generated chart points for generalFeeling: \(generatedPoints)")
        chartPointsForAttributes.append(generatedPoints)
        
        
        let labelSettings = ChartLabelSettings(font: UIFont.preferredFont(forTextStyle: .footnote), fontColor: Colour.primary, rotation: 0, rotationKeep: .bottom, shiftXOnRotation: false, textAlignment: .default)
                
        let generator = ChartAxisGeneratorMultiplier(2)
        let labelsGenerator = ChartAxisLabelsGeneratorFunc {scalar in
            return ChartAxisLabel(text: "\(Int(scalar))", settings: labelSettings)
        }
        
        let xGenerator = ChartAxisGeneratorMultiplier(2)
        
        let xModel = ChartAxisModel(lineColor: Colour.primary, firstModelValue: 1, lastModelValue: 30, axisTitleLabels: [ChartAxisLabel(text: "Day", settings: labelSettings)], axisValuesGenerator: xGenerator, labelsGenerator: labelsGenerator)
        
//        let xModel = ChartAxisModel(
        
        let yModel = ChartAxisModel(lineColor: Colour.primary, firstModelValue: 1, lastModelValue: 5, axisTitleLabels: [ChartAxisLabel(text: "", settings: labelSettings.defaultVertical())], axisValuesGenerator: generator, labelsGenerator: labelsGenerator)
        
        let chartFrame = self.chartViewContainer.bounds.insetBy(dx: 0, dy: 0)
        
        var chartSettings = ChartSettings()
        chartSettings.bottom = 10
        chartSettings.top = 25
        chartSettings.leading = 5
        chartSettings.trailing = 20
//        chartSettings.axisTitleLabelsToLabelsSpacing = 10
//        chartSettings.zoomPan = ChartSettingsZoomPan()
        //chartSettings.
        
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
            label.text = ""
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
        for chartPointsArray in chartPointsForAttributes {
            // create layer that uses viewGenerator to display chartpoints
            let chartPointsLayer = ChartPointsViewsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPointsArray, viewGenerator: viewGenerator, mode: .translate)
            let chartLineModel = ChartLineModel(chartPoints: chartPointsArray, lineColor: Colour.primary, animDuration: 1.0, animDelay: 0)
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
        
        self.chartViewContainer.addSubview(chart.view)
        self.chart = chart
    }
    
}
