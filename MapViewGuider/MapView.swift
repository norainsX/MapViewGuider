//
//  MapView.swift
//  MapViewGuider
//
//  Created by norains on 2020/2/26.
//  Copyright © 2020 norains. All rights reserved.
//

import MapKit
import SwiftUI

struct MapView: View {
    var mapViewState: MapViewState
    var mapViewDelegate: MapViewDelegate

    var body: some View {
        return GeometryReader { geometryProxy in
            MapViewWrapper(frame: CGRect(x: geometryProxy.safeAreaInsets.leading,
                                         y: geometryProxy.safeAreaInsets.trailing,
                                         width: geometryProxy.size.width,
                                         height: geometryProxy.size.height),
                           mapViewState: self.mapViewState,
                           mapViewDelegate: self.mapViewDelegate)
        }
    }
}

struct MapViewWrapper: UIViewRepresentable {
    var frame: CGRect
    var mapViewState: MapViewState
    var mapViewDelegate: MapViewDelegate

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: frame)
        mapView.delegate = mapViewDelegate
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    }
}
