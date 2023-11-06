//
//  TipCreaCate.swift
//  PPoint
//
//  Created by A. Ortega on 11/4/23.
//

import Foundation
import TipKit

struct TipCreaCate : Tip {
    
    var title : Text {
        Text("Change your emoji")
            .foregroundStyle(.indigo)
    }
    
    var message: Text? {
        Text("You can choose the emoji that you want for your category.")
    }
    
}
