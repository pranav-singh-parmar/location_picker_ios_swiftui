//
//  ContentView.swift
//  location-picker-swiftui
//
//  Created by Pranav Singh on 18/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var manager = LocationManager()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Location Picker App!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
