//
//  MapViewState.swift
//  MapViewGuider
//
//  Created by norains on 2020/2/26.
//  Copyright © 2020 norains. All rights reserved.
//

import MapKit

class MapViewState: ObservableObject {
    var span: MKCoordinateSpan?
    @Published var center: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 39.9, longitude: 116.38)
    var pinAnnotation: PinAnnotation?
    
    var navigateView: SecondContentView?
    @Published var activeNavigate = false

    init() {
        pinAnnotation = PinAnnotation(coordinate: CLLocationCoordinate2D(latitude: 39.9, longitude: 116.38), mapViewState: self)
    }
}
