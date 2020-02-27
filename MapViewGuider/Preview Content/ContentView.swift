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
    @ObservedObject var mapViewState = MapViewState()
    var mapViewDelegate: MapViewDelegate?

    init() {
        mapViewDelegate = MapViewDelegate(mapViewState: mapViewState)
    }

    var body: some View {
        NavigationView {
            ZStack {
                MapView(mapViewState: mapViewState, mapViewDelegate: mapViewDelegate!)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    Button(action: {
                        self.mapViewState.center = CLLocationCoordinate2D(latitude: 39.9, longitude: 116.38)
                    }
                    ) {
                        Text("MyLocation")
                            .background(Color.gray)
                            .padding()
                    }

                    if mapViewState.navigateView != nil {
                        NavigationLink(destination: mapViewState.navigateView!, isActive: $mapViewState.activeNavigate) {
                            EmptyView()
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
