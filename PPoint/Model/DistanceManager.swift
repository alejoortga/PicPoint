//
//  DistanceManager.swift
//  PPoint
//
//  Created by A. Ortega on 10/1/23.
//

import Foundation
import CoreLocation


class DistanceManager: ObservableObject {
    @Published var distance: CLLocationDistance = 0.0
    
    func updateDistance(_ newDistance: CLLocationDistance) {
        DispatchQueue.main.async {
            self.distance = newDistance
        }
    }
}
