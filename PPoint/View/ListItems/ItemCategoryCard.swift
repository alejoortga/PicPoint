//
//  ItemCategoryCard.swift
//  PPoint
//
//  Created by A on 8/21/23.
//

import SwiftUI
import SwiftData
import CoreLocation
import UserNotifications

struct ItemCategoryCard: View {
    
    var item : ItemForCategory
    
    @ObservedObject private var locationManagerActualLocation = LocationManager()
    
    init(item: ItemForCategory) {
        self.item = item
        locationManagerActualLocation.destinationLocation = CLLocation(latitude: item.latitude, longitude: item.longitude)
        locationManagerActualLocation.productName = item.productName
    }

    var body: some View {

        HStack{
            RoundedRectangle(cornerRadius: 15).frame(width: 50, height: 50).overlay{
                
                if let selectedPhotoData = item.image, let uiImage = UIImage(data: selectedPhotoData){
                    Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50).cornerRadius(9).clipped()
                }
            }
            
            VStack(alignment: .leading){
                
                Text(item.productName)
                    .fontWeight(.bold)
                    .font(.system(size: 21, design: .rounded))
                    .minimumScaleFactor(0.01)
              
                
                
                HStack{
                    
                    
                    Text("$\(item.productPrice)")

                        .foregroundStyle(.green)
                    
                    Spacer()
                    
                    HStack{
                        Image(systemName: "location.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Color(red: 255/255, green: 59/255, blue: 48/255))
                        
                        if CalculateDistance() <= 1000 {
                            Text("\(String(format: "%.2f", CalculateDistance())) m")
                                .foregroundColor(Color(red: 255/255, green: 59/255, blue: 48/255))
                        }else {
                            Text("\(String(format: "%.0f", CalculateDistance() / 1000 )) km")
                                .foregroundColor(Color(red: 255/255, green: 59/255, blue: 48/255))
                        }

                        
                        
                            
                    }
                }.font(.system(size: 12, design: .rounded).bold())
                
            }.padding(.leading, 10)
        }
    }
    private func CalculateDistance() -> CLLocationDistance {
        let userLocation = locationManagerActualLocation.location
        let destinationLocation = CLLocation(latitude: item.latitude, longitude: item.longitude)
        
        if let userLocation = userLocation {
            let distance = userLocation.distance(from: destinationLocation)

            return distance
        } else {
            return 0.0
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewSampleData.container
        return Group {
            ItemCategoryCard(item: ItemForCategory.preview)
                .modelContainer(container)
        }
    }
}
