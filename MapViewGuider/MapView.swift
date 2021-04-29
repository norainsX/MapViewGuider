//
//  MapView.swift
//  MapViewGuider
//
//  Created by norains on 2020/2/26.
//  Copyright © 2020 norains. All rights reserved.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @ObservedObject var mapViewState: MapViewState
    var mapViewDelegate: MapViewDelegate

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        // 添加代理
        mapView.delegate = mapViewDelegate
        // 添加大头针
        mapView.addAnnotation(mapViewState.pinAnnotation!)

        // Restruct -------------------- str
        // The .layer is temporary value
        mapViewState.initRendererManager(mkMapView: mapView, rendererType: .layer)
        mapViewState.rendererManager?.trackRenderer.open()

        // mapViewState.rendererManager?.trackRenderer.switchRendererMode(rendererMode: .clear)

        if let layer = mapViewState.rendererManager?.trackRenderer.CALayer {
            mapView.layer.addSublayer(layer)
        }

        // The temp coordinates for testing only
        mapViewState.rendererManager?.trackRenderer.addStaticTrack(coordinates: mapViewState.tracks)
        // Restruct -------------------- end

        /*
         // 添加轨迹
         let polyline = MKPolyline(coordinates: mapViewState.tracks, count: mapViewState.tracks.count)
         mapView.addOverlay(polyline)
         // 添加SubLayer
         mapView.layer.addSublayer(mapViewState.fogLayer)
         mapViewState.fogLayer.mapView = mapView
         mapViewState.fogLayer.frame = UIScreen.main.bounds
         mapViewState.fogLayer.displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
         mapViewState.fogLayer.setNeedsDisplay()
          */

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        // 设置中心点
        if let center = mapViewState.center {
            var region: MKCoordinateRegion
            if let span = mapViewState.span {
                region = MKCoordinateRegion(center: center,
                                            span: span)
            } else {
                region = MKCoordinateRegion(center: center,
                                            latitudinalMeters: CLLocationDistance(400),
                                            longitudinalMeters: CLLocationDistance(400))
            }
            view.setRegion(region, animated: true)

            mapViewState.center = nil
        }
    }
}
