//
//  YPDRecordViewController.swift
//  Benson
//
//  Created by Aaron Baw on 05/03/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import UIKit
//import ResearchKit

//@IBDesignable
class YPDRecordViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // The fourth step is a vertical scale control that allows continuous movement.
//        let step4AnswerFormat = ORKAnswerFormat.continuousScale(withMaximumValue: 5.0, minimumValue: 1.0, defaultValue: 99.0, maximumFractionDigits: 2, vertical: true, maximumValueDescription: "Fantastic", minimumValueDescription: "Horrible")
//        
//        let questionStep4 = ORKQuestionStep(identifier: "generalFeeling", title: "general feeling", question: "How are you feeling?", answer: step4AnswerFormat)
//        
//        questionStep4.text = "Continuous Vertical Scale"
//        
//        // The fifth step is a scale control that allows text choices.
//        let _: [ORKTextChoice] = [ORKTextChoice(text: "Poor", value: 1 as NSCoding & NSCopying & NSObjectProtocol), ORKTextChoice(text: "Fair", value: 2 as NSCoding & NSCopying & NSObjectProtocol), ORKTextChoice(text: "Good", value: 3 as NSCoding & NSCopying & NSObjectProtocol), ORKTextChoice(text: "Above Average", value: 10 as NSCoding & NSCopying & NSObjectProtocol), ORKTextChoice(text: "Excellent", value: 5 as NSCoding & NSCopying & NSObjectProtocol)]
//        
//        let task = ORKOrderedTask(identifier: "checkin", steps: [questionStep4])
//        
//        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
//        
//        self.present(taskViewController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
