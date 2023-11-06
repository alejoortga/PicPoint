//
//  routeItem.swift
//  PPoint
//
//  Created by A. Ortega on 10/16/23.
//

import SwiftUI
import MapKit
import CoreLocation

struct routeItem: View {
    
    @State private var location = CLLocationCoordinate2D(latitude: 25.80765, longitude: -80.123717)
    @StateObject var locationDataManager = LocationManager()
    @State private var cityName : String = ""
    @State private var position : MapCameraPosition = .automatic
    
    var item : ItemForCategory
    @State private var mapSelection : MKMapItem?
    
    @State private var showDetails : Bool = false
    
    @State private var lookAroundScene : MKLookAroundScene?
    
    @State private var viewingRegion : MKCoordinateRegion?
    
    @State private var locations : [MKMapItem] = []
    
    @State private var routeDisplaying : Bool = false
    @State private var route : MKRoute?
    
    @State private var isRouteVisible = true
    
    @ObservedObject private var locationManagerActualLocation = LocationManager()
    
    let stroke = StrokeStyle(
    lineWidth: 5,
    lineCap: .round, lineJoin: .round
    )
    
    @State private var timer : Timer? = nil
    @State private var startUpdating : Bool = false
    @State private var isCreatingRoute : Bool = false
    @State private var routeDestination : MKMapItem?
    
    var body: some View {
        
        NavigationStack{
            VStack{
                
                switch locationDataManager.locationManager .authorizationStatus{
                    
                case .authorizedAlways, .authorizedWhenInUse:
                    
                    Map(position: $position, selection: $mapSelection){
                        ForEach(locations, id: \.self){ mapItem in
                            let placemark = mapItem.placemark
                            Marker(item.productName,systemImage: "heart.circle.fill", coordinate: placemark.coordinate)
                                .stroke(Color.primary, style: stroke)}
                        if let route {
                            MapPolyline(route.polyline)
                                .stroke(.yellow, lineWidth: 7)
                        }else if isRouteVisible == false{
                            MapPolyline(coordinates: [location, locationManagerActualLocation.location?.coordinate ?? CLLocationCoordinate2D()])
                                .stroke(Color.primary, style: stroke)
                        }
                        UserAnnotation()
                    }.mapControls{
                        MapCompass()
                    }.onChange(of: isRouteVisible) {
                        position = .automatic}
                    .mapStyle(.standard(elevation: .realistic)).ignoresSafeArea(.all).onAppear{
                        location.latitude = item.latitude
                        location.longitude = item.longitude
                        
                        let placemark = MKPlacemark(coordinate: location)
                        
                        let mapItem = MKMapItem(placemark: placemark)
                        
                        locations.append(mapItem)
                        getCityName()
                    }
                    .onChange(of: mapSelection) { oldValue, newValue in
                        showDetails = newValue != nil
                        fetchLookAroundPreview()
                        
                        
                    }.safeAreaInset(edge: .bottom) {
                        HStack{

                            Spacer()
                            VStack{
                                Button(action: {
                                    if self.isCreatingRoute {
                                        // Stop creating route
                                        self.startUpdating = false
                                        self.isCreatingRoute = false
                                        withAnimation(.easeInOut){
                                            routeDisplaying = false
                                            mapSelection = routeDestination
                                            routeDestination = nil
                                            route = nil
                                            position = .automatic
                                            isRouteVisible = true
                                        }
                                    } else {
                                        // Start creating route
                                        self.startUpdating = true
                                        self.isCreatingRoute = true
                                        fetchRoute()
 
                                    }
                                }, label: {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 14).frame(width : 125 ,height: 50).overlay{
                                        Text(isCreatingRoute ? "Finish Route" : "Create Route").foregroundStyle(Color.primary).font(.system(size: 17, design: .rounded).bold())
                                    }.foregroundStyle(.ultraThinMaterial).opacity(1)
                                    
                                    Spacer()
                                }).padding(.top, 30)
                            }
                        }
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
    
    private func getCityName(){
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
    
    func fetchLookAroundPreview(){
        if let mapSelection {
            lookAroundScene = nil
            
            Task{
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
    
    private func fetchRoute() {
        

        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationDataManager.locationManager.location!.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: location))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                withAnimation(.snappy){
                    self.route = route
                    self.routeDisplaying = true
                    
                    routeDestination = mapSelection
                    
                    
                }
            } else {
                isRouteVisible.toggle()
            }
        }
    }
}

#Preview {
    
    MainActor.assumeIsolated {
        let container = PreviewSampleData.container
        
        return Group{
            routeItem(item: ItemForCategory.preview)
                .modelContainer(container)
        }
    }
}
