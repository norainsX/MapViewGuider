//
//  ContentView.swift
//  MapViewGuider
//
//  Created by norains on 2020/2/26.
//  Copyright © 2020 norains. All rights reserved.
//

import MapKit
import SwiftUI

struct ContentView: View {
    var mapViewState: MapViewState?
    var mapViewDelegate: MapViewDelegate?

    init() {
        mapViewState = MapViewState()
        mapViewDelegate = MapViewDelegate(mapViewState: mapViewState!)
    }

    var body: some View {
        ZStack {
            MapView(mapViewState: mapViewState!, mapViewDelegate: mapViewDelegate!)
            /*
             VStack {
                 Spacer()
                 Button(action: {
                     //self.mapViewState.center = CLLocationCoordinate2D(latitude: 49.9, longitude: 116.4)
                 }
                 ) {
                     Text("MyLocation")
                         .background(Color.gray)
                         .padding()
                 }
             }
             */
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
