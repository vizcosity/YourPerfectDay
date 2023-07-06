//
//  YPDCheckinViewController.swift
//  Benson
//
//  Created by Aaron Baw on 31/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import UIKit
import SwiftUI

class YPDSubmitCheckinViewController: UIHostingController<YPDSubmitCheckinView> {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: YPDSubmitCheckinView())
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
