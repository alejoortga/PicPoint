//
//  ItemForCategory.swift
//  PPoint
//
//  Created by A on 8/21/23.
//

import Foundation
import SwiftData

@Model final class ItemForCategory {
    
    var productName : String
    var productPrice : String
    var productDescription : String
    var latitude : Double
    var longitude : Double
    var image : Data?
    var category : Category?
    
    init(productName: String, productPrice: String, productDescription: String, latitude: Double, longitude: Double, image: Data?) {
        self.productName = productName
        self.productPrice = productPrice
        self.productDescription = productDescription
        self.latitude = latitude
        self.longitude = longitude
        self.image = image
    }
    
}


extension ItemForCategory{
    static var preview : ItemForCategory{
        let imageData = Data()
        
        let item = ItemForCategory(productName: "Botero", productPrice: "2400000", productDescription: "I saw in this store the perfect spaguetti to make my delicious pasta!", latitude: 25.778252, longitude: -80.132182, image: imageData)
        
        item.category = .preview
        return item
    }
}
