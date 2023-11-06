//
//  routeMapItem.swift
//  PPoint
//
//  Created by A on 8/27/23.
//

import SwiftUI
import MapKit
import CoreLocation
import UserNotifications


struct routeMapItem: View {
    
    
    
    @State private var location = CLLocationCoordinate2D(latitude: 25.80765, longitude: -80.123717)

    
    @StateObject var locationDataManager = LocationManager()
    @State private var cityName: String = ""
    @State private var selectedTag : Int?
    @State private var position : MapCameraPosition = .automatic
    
    var item : ItemForCategory
    
    @ObservedObject private var locationManagerActualLocation = LocationManager()
    
    @State private var isRouteVisible = true
    
    @State private var savedCoordinates: [CLLocationCoordinate2D] = []

    let stroke = StrokeStyle(
    lineWidth: 5,
    lineCap: .round, lineJoin: .round
    )
    
    //Route
    @State private var selectedResult : MKMapItem?
    @State private var route : MKRoute?
    
    

    var body: some View {
        
        
        
        NavigationView{
            VStack{
                
                
                switch
                locationDataManager.locationManager
                    .authorizationStatus{
                case .authorizedWhenInUse, .authorizedAlways:

                    Map(position: $position, selection: $selectedTag){
                        if isRouteVisible == false {
                            
                            MapPolyline(coordinates: [location, locationManagerActualLocation.location?.coordinate ?? CLLocationCoordinate2D()])
                                .stroke(Color(red: 76/255, green: 217/255, blue: 100/255), style: stroke)
                            
                        }

                        Marker(item.productName,systemImage: "heart.circle.fill", coordinate: location)
                                .tag(1)
                                .tint(Color(red: 255/255, green: 59/255, blue: 48/255))
                        
                        
                        Marker("You",systemImage: "person.circle.fill" ,coordinate: locationManagerActualLocation.location?.coordinate ?? CLLocationCoordinate2D())
                            .tag(2)
                            .tint(.black)
                        
                    }.mapStyle(.standard(elevation: .realistic))
                    .ignoresSafeArea(.all)
                    .onAppear{
                        location.latitude = item.latitude
                        location.longitude = item.longitude
                        getCityName()
                    } 
                    
                    
                    .safeAreaInset(edge: .bottom) {
                            HStack{

                                Spacer()
                                VStack{
                        

                                    Button(action: {
                                        isRouteVisible.toggle()
        
                                    }, label: {
                                        Spacer()
                                        RoundedRectangle(cornerRadius: 14).frame(width : 125 ,height: 50).overlay{
                                            Text("Create Route").foregroundStyle(Color.primary).font(.system(size: 17, design: .rounded).bold())
                                        }.foregroundStyle(.ultraThinMaterial).opacity(1)
                                        
                                        Spacer()
                                    }).padding(.top, 30)
                                }
                            }
                        }.onChange(of: isRouteVisible) {
                            position = .automatic

                        }

                case .restricted, .denied:
                    
                    Text("Current location data was restricted or denied.")
                case .notDetermined:        // Authorization not determined yet.
                    Text("Finding your location...")
                    ProgressView()
                default:
                    ProgressView()
                }
            }.navigationTitle(cityName.isEmpty ? "City not found" : cityName)
                .toolbarBackground(.hidden, for: .navigationBar)
        }
        
    }
    
    private func getCityName() {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    DispatchQueue.main.async {
                        cityName = city
                    }
                } else {
                    DispatchQueue.main.async {
                        cityName = "City not found"
                    }
                }
            }
        }
    }
    
    
    private func CalculateDistance() -> CLLocationDistance {
        let userLocation = locationManagerActualLocation.location
        let destinationLocation = CLLocation(latitude: item.latitude, longitude: item.longitude)
        
        if let userLocation = userLocation{
            return userLocation.distance(from: destinationLocation)
        }else {
            return 0.0
        }
    }
    
    
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewSampleData.container
        
        return Group {
            
            routeMapItem(item: ItemForCategory.preview)
                .modelContainer(container)
        }
    }
}

