//
//  TipModels.swift
//  PPoint
//
//  Created by A. Ortega on 10/21/23.
//

import Foundation
import SwiftUI
import TipKit



struct PicPointTip : Tip {
    
    var title : Text {
        Text("Create a new category")
            .foregroundStyle(.indigo)
    }
    
    var message: Text? {
        Text("You can create awesome categories with differents colors for your items.")
    }
    
    var image: Image? {
        Image(systemName: "circle.dotted.and.circle")
        
    }
}

