//
//  MapViewDelegate.swift
//  MapViewGuider
//
//  Created by norains on 2020/2/26.
//  Copyright © 2020 norains. All rights reserved.
//

import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate {
    var mapViewState: MapViewState

    init(mapViewState: MapViewState) {
        self.mapViewState = mapViewState
    }

    // 地图放大缩小的时候回回调此函数
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        mapViewState.span = mapView.region.span
    }

    // 创建大头针的时候会回调此函数
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If the return value of MKAnnotationView is nil, it would be the default
        var annotationView: MKAnnotationView?

        let identifier = "MKPinAnnotationView"
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }

        annotationView?.annotation = annotation

        if let pinAnnotation = annotation as? PinAnnotation {
            pinAnnotation.makeTextAccessoryView(annotationView: annotationView as! MKPinAnnotationView)
        }

        return annotationView
    }

    // 创建renderer的时候会回调此函数
    func mapView(_ mapView: MKMapView, rendererFor: MKOverlay) -> MKOverlayRenderer {
        let renderer = PolylineRenderer(overlay: rendererFor)
        return renderer
    }
}
