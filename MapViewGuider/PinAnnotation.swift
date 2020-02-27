//
//  PinAnnotation.swift
//  MapViewGuider
//
//  Created by norains on 2020/2/27.
//  Copyright © 2020 norains. All rights reserved.
//

import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
