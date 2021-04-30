//
//  RendererManager.swift
//  WorldRoad
//
//  Created by norains on 2021/04/25.
//  Copyright © 2019 norains. All rights reserved.
//

import MapKit

class RendererManager {
    private var mkMapView: MKMapView
    private(set) var trackRenderer: TrackRenderer
    private var rendererType: RendererType

    init(mkMapView: MKMapView, rendererType: RendererType) {
        self.mkMapView = mkMapView
        self.rendererType = rendererType
        trackRenderer = RendererManager.createNewTrackRender(mkMapView: mkMapView, rendererType: rendererType)
        (trackRenderer as! TrackUtility).open()
    }

    enum RendererType: Int {
        case polyline
        case layer
    }

    func switchTrackRenderer(rendererType: RendererType) {
        if self.rendererType == rendererType {
            // Do nothing
            return
        }

        // Release the resource
        (trackRenderer as! TrackUtility).close()

        trackRenderer = RendererManager.createNewTrackRender(mkMapView: mkMapView, rendererType: rendererType)
        (trackRenderer as! TrackUtility).open()
    }

    private static func createNewTrackRender(mkMapView: MKMapView, rendererType: RendererType) -> TrackRenderer {
        if rendererType == .layer {
            return LayerRenderer(mkMapView: mkMapView)
        } else {
            return PolylineRenderer(mkMapView: mkMapView)
        }
    }
}
