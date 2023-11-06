//
//  PPointApp.swift
//  PPoint
//
//  Created by A on 8/21/23.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct PPointApp: App {
    @AppStorage("hasShownOnboarding") var hasShownOnboarding = false
    
    @ObservedObject private var locationManagerActualLocation = LocationManager()

    var body: some Scene {
        WindowGroup {
            if hasShownOnboarding {
                ContentView()
                    .task {
                        try? Tips.configure([
                            .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault)
                        ])
                    }
            } else {
                OnBoardingView()
            }
        }
        .modelContainer(for: [Category.self, ItemForCategory.self])
    }
}
