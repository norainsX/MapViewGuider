//
//  MapViewDelegate.swift
//  MapViewGuider
//
//  Created by norains on 2020/2/26.
//  Copyright © 2020 norains. All rights reserved.
//

import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate {
    var mapViewState : MapViewState
    
    init(mapViewState : MapViewState){
        self.mapViewState = mapViewState
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        mapViewState.span = mapView.region.span
        print(mapViewState.span)
    }
}
