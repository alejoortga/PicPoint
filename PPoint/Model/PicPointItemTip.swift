//
//  PicPointItemTip.swift
//  PPoint
//
//  Created by A. Ortega on 10/21/23.
//

import Foundation
import TipKit


struct PicPointItemTip : Tip {
    
    var title : Text {
        Text("Add new items")
            .foregroundStyle(.indigo)
    }
    
    var message: Text? {
        Text("You can add any items you wants, also for each item you can create your route and walk rite or wathever you want for it.")
    }
    
    var image: Image? {
        Image(systemName: "lightspectrum.horizontal")
        
    }
}
