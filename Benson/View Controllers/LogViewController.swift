//
//  LogViewController.swift
//  Benson
//
//  Created by Aaron Baw on 27/08/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit

var metricLogs : [MetricLog] = [
    MetricLog(metrics: [MetricAttribute(name: "Mood", value: 3), MetricAttribute(name: "Feeling", value: 2)], timeSince: "yesterday"),
    MetricLog(metrics: [MetricAttribute(name: "Energy", value: 5), MetricAttribute(name: "Focus", value: 1)], timeSince: "last week")
]

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    
    // Hold a copy of the fetcher in order to cache any metric logs.
    var fetcher: Fetcher = Fetcher()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metricLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MetricLogCell")! as! CheckinCollectionViewCell
        cell.metricLog = metricLogs[indexPath.row]
        
        return cell
    }
    
        
    var logs: [MetricLog] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(fetcher.fetchMetricLogs(completionHandler: { ([MetricLog]) in
            //
        }))
    }
    
    
    

}
