//
//  LocationManager.swift
//  location_picker_swiftui
//
//  Created by MacBook PRO on 05/10/23.
//

import Foundation
import CoreLocation

//https://medium.com/@pblanesp/how-to-display-a-map-and-track-the-users-location-in-swiftui-7d288cdb747e#:~:text=Showing%20the%20user%20location%20is,parameters%20to%20the%20Map%20view.&text=The%20first%20new%20property%20is,which%20will%20do%20just%20that.
final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.setup()
    }
    
    func setup() {
        switch locationManager.authorizationStatus {
        //        case .authorizedAlways:
        //            locationManager.startUpdatingLocation()
        //        case .authorizedWhenInUse:
        //            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedAlways == manager.authorizationStatus else { return }
        //locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locationManager.stopUpdatingLocation()
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")

//        locations.last.map {
//            region = MKCoordinateRegion(
//                center: $0.coordinate,
//                span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
//            )
//        }
    }
}
