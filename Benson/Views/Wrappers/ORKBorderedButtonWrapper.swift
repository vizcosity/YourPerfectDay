//
//  ORKBorderedButtonWrapper.swift
//  Benson
//
//  Created by Aaron Baw on 30/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI
import ResearchKit

final class ORKBorderedButtonWrapper: UIViewRepresentable {
    
    init(title: String, action: @escaping () -> Void){
        self.title = title
        self.action = action
    }
    
    var title: String
    @objc var action: () -> Void
    
    typealias UIViewType = ORKTextButton
    
    func makeUIView(context: Context) -> ORKTextButton {
        let button = ORKTextButton()
        button.setTitle(self.title, for: .normal)
        
        button.addTarget(self, action: #selector(getter: action), for: .touchUpInside)
        
        return button
    }
    
    func updateUIView(_ uiView: ORKTextButton, context: Context) {
        uiView.setTitle(self.title, for: .normal)
    }
 
}

struct ORKBorderedButtonWrapper_Previews: PreviewProvider {
    static var previews: some View {
        ORKBorderedButtonWrapper(title: "Submit", action: {
            print("Tapped")
        })
    }
}
