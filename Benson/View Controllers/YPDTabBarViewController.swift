//
//  YPDTabBarViewController.swift
//  Benson
//
//  Created by Aaron Baw on 20/06/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import UIKit
import SwiftUI

class YPDTabBarViewController: UIHostingController<YPDTabBarView> {

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder, rootView: YPDTabBarView())
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Reassign the root view to make use of the @Binding held at this level.
            self.rootView = YPDTabBarView()
            
        }
        

}
