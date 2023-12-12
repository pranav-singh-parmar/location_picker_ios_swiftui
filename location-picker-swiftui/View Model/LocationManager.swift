//
//  LocationManager.swift
//  location_picker_swiftui
//
//  Created by MacBook PRO on 05/10/23.
//

import Foundation
import CoreLocation
import MapKit

//https://medium.com/@pblanesp/how-to-display-a-map-and-track-the-users-location-in-swiftui-7d288cdb747e#:~:text=Showing%20the%20user%20location%20is,parameters%20to%20the%20Map%20view.&text=The%20first%20new%20property%20is,which%20will%20do%20just%20that.

//MARK:- LocationManager
final class LocationManager: NSObject, ObservableObject {
    
    @Published var clAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    
    @Published var region = MKCoordinateRegion(
            center: .init(latitude: 37.334_900, longitude: -122.009_020),
            span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.setup()
    }
    
    private func setup() {
        clAuthorizationStatus = locationManager.authorizationStatus
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("in Location authorized")
        case .denied:
            print("in Location .denied")
            presentAppSettingsAlert()
        case .restricted:
            print("in Location .restricted")
            presentAppSettingsAlert()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            print("in Location .notDetermined")
        @unknown default:
            print("in Location @unknown default")
        }
    }
    
    func presentAppSettingsAlert() {
        let message = (Bundle.main.appName ?? "") +
        " " + AppTexts.AlertMessages.requiresAccessToLocationToProceed +
        " " + AppTexts.AlertMessages.goToSettingsToGrantAccess
        let alert = UIAlertController(ofStyle: .alert,
                                      withTitle: AppTexts.AlertMessages.accessDenied,
                                      andMessage: message)
        
        alert.addAction(havingTitle: AppTexts.AlertMessages.openSettings,
                        ofStyle: .default) { _ in
            if let settings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settings) {
                UIApplication.shared.open(settings)
            }
        }
        
        alert.addAction(havingTitle: AppTexts.AlertMessages.cancel,
                        ofStyle: .cancel)
        
        alert.present()
    }
}

//MARK:- CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.clAuthorizationStatus = manager.authorizationStatus
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
        let locValue = manager.location?.coordinate
        print("locations = \(locValue?.latitude ?? 0) \(locValue?.longitude ?? 0)")

        locations.last.map {
                region = MKCoordinateRegion(
                    center: $0.coordinate,
                    span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
    }
}
