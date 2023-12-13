//
//  ContentView.swift
//  location-picker-swiftui
//
//  Created by Pranav Singh on 18/10/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var region = MapCameraPosition.userLocation(fallback:
                                                                MapCameraPosition.region(MKCoordinateRegion(
                                                                    center: .init(latitude: 37.334_900, longitude: -122.009_020),
                                                                    span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2))))
    
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            switch locationManager.clAuthorizationStatus {
            case .restricted, .denied:
                VStack(spacing: spacing) {
                    Spacer()
                    
                    Text(AppTexts.grantContactAccessToViewCurrentLocationOnThisApp)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        locationManager.presentAppSettingsAlert()
                    } label: {
                        Text(AppTexts.openSettings)
                            .font(.system(.headline))
                    }
                    Spacer()
                }.padding(padding)
            case .authorized, .authorizedAlways, .authorizedWhenInUse:
                
                //only availalbe in iOS 17+
                Map(position: $region)
                
                //                it shows error, might be some issue in MapKit
                //                https://stackoverflow.com/questions/71953853/swiftui-map-causes-modifying-state-during-view-update
                //                Map(coordinateRegion: $region,
                //                    interactionModes: .all,
                //                    showsUserLocation: true,
                //                    userTrackingMode: .constant(.none)
                //                )
                    .edgesIgnoringSafeArea(.all)
            default:
                EmptyView()
            }
        }.onReceive(locationManager.$region) { region in
            self.region = MapCameraPosition.userLocation(fallback: MapCameraPosition.region(region))
        }.onDisappear {
            locationManager.stopUpdatingLocation()
        }
    }
}

#Preview {
    ContentView()
}
