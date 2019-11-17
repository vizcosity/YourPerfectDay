//
//  FirstViewController.swift
//  Benson
//
//  Created by Aaron Baw on 18/08/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit
import Alamofire

struct Webserver {
    static var endpoint = Bundle.main.object(forInfoDictionaryKey: "Webserver Endpoint") as! String
    static var getMetrics: String = "\(Webserver.endpoint)/metrics"
    static var getLastCheckin: String = "\(Webserver.endpoint)/lastCheckin"
    static var submitCheckin: String = "\(Webserver.endpoint)/checkin"
}

@IBDesignable
class RecordViewController: UIViewController, MetricSelectionDelegate {
    
    @IBOutlet weak var retrieveMetricSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var retrieveLastCheckinSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var gradientView: GradientView!
    
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var lastCheckinLabel: UILabel!
    
    @IBOutlet weak var metricPromptStackView: UIStackView!
    
    var metricPrompts : [[String: Any]] = [["title": "I'm feeling", "responses": ["Horrible", "Meh", "Okay", "Not Bad", "Great"]]] {
        didSet {
            
            // Stop animating the spinner if so.
            retrieveMetricSpinner?.stopAnimating()
            
            metricPrompts.forEach { (metricPrompt) in
                addOrUpdate(metricPrompt: metricPrompt)
            }
        }
    }
    
    var selectedMetrics : [(String, Int)] = []
    
    func addOrUpdate(metricPrompt: [String: Any]) {
        let metricPromptView = MetricPromptView()
        metricPromptView.metricTitle = metricPrompt["title"] as? String ?? ""
        metricPromptView.metricId = metricPrompt["metricId"] as? String ?? "Unassigned Metric ID"
        metricPromptView.responses = (metricPrompt["responses"] as? [[String: Any]])?.map({ (prompt) -> String in
            return prompt["title"] as? String ?? ""
        }) ?? []
        metricPromptView.actionDelegate = self
       
        if (!metricPromptStackView.arrangedSubviews.contains(metricPromptView)){
            
            print("Adding \(metricPromptView.metricId)")
            metricPromptStackView.addArrangedSubview(metricPromptView)
        }
    }
    
    func fetchAndInsertMetricPrompts(){
        
        print("Fetching metric prompts from \(Webserver.getMetrics)")
        
        // Start spinner.
        retrieveMetricSpinner?.startAnimating()
        
        AF.request(Webserver.getMetrics).responseJSON(queue: DispatchQueue.global(qos: .userInitiated), options: .allowFragments) { (response) in
            print("Recieved resposne: \(response)")
                if let metricPrompts = try? response.result.get() as? [[String: Any]] {

                    // Setting this variable will cause the UI to update, therefore we cannot perform this action on an 'off-global' view.
                    DispatchQueue.main.async { [weak self] in
                        // In case the asynchronous request takes too long, the VC which instantiated it, and would recieve the update, may not even be on the heap anymore. However, this closure would maintain a reference to the VC and keep it on the heap, unnecessarily. If we make it a weak reference, however, we prevent this from happening.
                        self?.metricPrompts = metricPrompts
                    }
                }
        }

    }
    
    
    @IBAction func submitCheckin(_ sender: Any) {
        
        print("Selected metrics [\(selectedMetrics.count)]: \(selectedMetrics)")
        
//        selectedMetrics.forEach { (metricId, responseValue) in
//            checkin(forMetricId: metricId, withValue: responseValue)
//        }

        checkin(metricResposnes: selectedMetrics.map({ (metricId, responseValue) -> [String: Any] in
            return [
                "metricId": metricId,
                "value": responseValue
            ]
        }))
        
        clearSelectedMetrics()
        
    }
    
    func fetchAndInsertLastCheckin(){
       
        retrieveLastCheckinSpinner.startAnimating()
        
        AF.request(Webserver.getLastCheckin).responseString(queue: DispatchQueue.global(qos: .background)) {
                response in
            
            // Remember to retrieve a weak reference to self so that we do not increment the pointer to self on the heap - want to allow it to be removed if something happens and it is no longer necessary.
            DispatchQueue.main.async { [weak self] in
                if let lastCheckin = try? response.result.get() {
                    self?.lastCheckinLabel.text = "last checkin: \(lastCheckin)"
                    
                    // We can stop the checkin spinner here because we are directly manpiluating the value from within this closure.
                    self?.retrieveLastCheckinSpinner?.stopAnimating()
                }
            }
            
        }
    }
    
    func getMetricPrompt(byId id: String) -> [String: Any]? {
        let filteredPrompts = self.metricPrompts.filter { (prompt) -> Bool in
            return prompt["metricId"] as? String == id
        }
        
        return filteredPrompts.count == 1 ? filteredPrompts[0] : nil
    }
    
    func clearSelectedMetrics(){
        selectedMetrics = []
        metricPromptStackView.arrangedSubviews.forEach {
            if let metricPromptView = ($0 as? MetricPromptView) {
                metricPromptView.clearAnySelected()
            }
        }
    }
    
    func checkin(forMetricId id: String, withValue value: Int){
        
        print("Attempting to checkin for \(id) with value \(value)")
        
        AF.request(Webserver.submitCheckin, method: .post, parameters: [
            "metricId": id,
            "value": value
            ], encoding: JSONEncoding.default).responseJSON { (response) in
                do {
                    if let result = try response.result.get() as? [String:Any] {
                        if result["success"] as? Int == 1 {
                            print("Successfully submitted checkin for \(id) with value \(value)")
                        }
                    }
                    
                    self.fetchAndInsertLastCheckin()
                } catch {
                    print("Could not submit checkin: \(error)")
                }
        }
    }
    
    func checkin(metricResposnes: [[String: Any]]){
        print("Attempting to checkin for metricResponses: \(metricResposnes)")
        
        AF.request(Webserver.submitCheckin, method: .post, parameters: [
            "array": metricResposnes
            ],
                   encoding: JSONEncoding.default).responseJSON { (response) in
            do {
                if let result = try response.result.get() as? [String:Any] {
                    if result["success"] as? Int == 1 {
                        print("Successfully submitted checkin for \(metricResposnes.count) metricResponses")
                    }
                }
                
                self.fetchAndInsertLastCheckin()
            } catch {
                print("Could not submit checkin: \(error)")
            }
        }
    }
    
    // Delegate implementations.
    func didSelectMetric(responseIndex: Int, withMetricId metricId: String) {
        print("Did select metric action recieved for responseIndex: \(responseIndex) and metricId \(metricId)")
        if let metric = getMetricPrompt(byId: metricId) {
            if let responses = metric["responses"] as? [[String: Any]] {
                if let responseValue = responses[responseIndex]["value"] as? Int {
//                    checkin(forMetricId: metricId, withValue: responseValue)
                    
                    // Ensure we only add the selected metric if it has not already been added to the array.
                    selectedMetrics = selectedMetrics.filter({ (tuple) -> Bool in
                        let (selectedId, _) = tuple
                        return metricId != selectedId
                    })
                    
                    selectedMetrics.append((metricId, responseValue))
                    
                    print("Selected metrics after adding \(metricId): \(selectedMetrics)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchAndInsertMetricPrompts()
        fetchAndInsertLastCheckin()
        
    }

}
