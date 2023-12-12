//
//  ContentView.swift
//  location-picker-swiftui
//
//  Created by Pranav Singh on 18/10/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    
    private let spacing: CGFloat = 10
    private let padding: CGFloat = 16
    
    var body: some View {
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
            Map(coordinateRegion: $locationManager.region,
                showsUserLocation: true)
                       .edgesIgnoringSafeArea(.all)
        default:
            EmptyView()
        }
    }
}

#Preview {
    ContentView()
}
