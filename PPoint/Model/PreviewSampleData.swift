//
//  PreviewSampleData.swift
//  PPoint
//
//  Created by A on 8/21/23.
//

import SwiftUI
import SwiftData

actor PreviewSampleData{
    @MainActor
    static var container : ModelContainer {
        
        do {
            let schema = Schema([Category.self, ItemForCategory.self])
            let configuration = ModelConfiguration()
            let container = try! ModelContainer(for: schema, configurations: [configuration])
            let sampleData : [any PersistentModel] = [Category.preview, ItemForCategory.preview]
            sampleData.forEach {
                container.mainContext.insert($0)
            }
            return container
        } catch {
            fatalError("Failed to create container")
        }
    }
}

