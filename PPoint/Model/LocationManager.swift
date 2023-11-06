import Foundation
import CoreLocation
import UserNotifications

class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var authorizationStatus : CLAuthorizationStatus?
    @Published var location: CLLocation? = nil
    @Published var errorDescription: String? = nil
    var productName : String?
    
    var notificationShown = false
    @Published var distance: CLLocationDistance? = nil
    var destinationLocation : CLLocation?
    
    var locationUpdateTimer: Timer?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = false
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error al solicitar autorización para notificaciones: \(error)")
            } else if granted {
                print("Permiso para notificaciones concedido")
                
            } else {
                print("Permiso para notificaciones denegado")
            }
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        print("Actualizando ubicacion")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways :
            authorizationStatus = .authorizedWhenInUse
            locationManager.startUpdatingLocation()
            
        case .restricted :
            authorizationStatus = .restricted
            
        case .denied :
            authorizationStatus = .denied
            
        case .notDetermined :
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            
        default:
            break
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        self.location = location
        
        if let destinationLocation = destinationLocation{
            calculateDistance(from: location, to: destinationLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error.localizedDescription)")
        
        self.errorDescription = "We can't load the location"
    }
    
     func calculateDistance(from userLocation: CLLocation, to destinationLocation: CLLocation) {
        let distance = userLocation.distance(from: destinationLocation)
        
        print("Distance to destination: \(distance) distance \(String(describing: productName))")
        
        self.distance = distance
        if distance <= 100 && !notificationShown {
            
            showNotification(with: distance)
            notificationShown = true
            
        } else if distance > 300 {
            // Restablece la variable cuando la distancia es > 10
            
            notificationShown = false
        }
    }
    
    private func showNotification(with distance: CLLocationDistance){
        let content = UNMutableNotificationContent()
        content.title = "Notificacion de distancia"
        content.body = "Oye estas a \(distance) metros de tu \(productName ?? "")"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let requestIdentifier = "distanceNotification"
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error al agregar notificación con identificador \(requestIdentifier): \(error)")
            }
        }
    }
}
