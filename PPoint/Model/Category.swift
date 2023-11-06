//
//  Category.swift
//  PPoint
//
//  Created by A on 8/21/23.
//

import Foundation
import SwiftUI
import SwiftData


@Model final class Category {
    var categoryName : String
    var emojiCategory : String
    var startDate : Date
    var red : Double
    var green : Double
    var blue : Double
    var opacity : Double
    
    @Relationship(deleteRule: .cascade, inverse: \ItemForCategory.category)
    var itemForCategory : [ItemForCategory] = []
    
    
    init(categoryName: String, emojiCategory: String, startDate: Date, red: Double, green: Double, blue: Double, opacity: Double) {
        self.categoryName = categoryName
        self.emojiCategory = emojiCategory
        self.startDate = startDate
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }
}


extension Category {
    @Transient
    
    static var preview: Category{
        Category(categoryName: "Pokemon", emojiCategory: "🐲", startDate: .now, red: 0.086, green: 0.575, blue: 0.718, opacity: 1.0)
    }
}
