//
//  PolylineRenderer.swift
//  WorldRoad
//
//  Created by norains on 2021/04/25.
//  Copyright © 2019 norains. All rights reserved.
//
import MapKit

class PolylineRenderer: TrackUtility, TrackRenderer {
    private var dynamicTrackPolyline: MKPolyline?
    private var trackPolylineRenderer: TrackPolylineRenderer?
    private var staticPolylines = [StaticTrackID: MKPolyline]()
    private var rendererMode = RendererMode.clear

    override init(mkMapView: MKMapView) {
        super.init(mkMapView: mkMapView)

        trackPolylineRenderer = TrackPolylineRenderer()
        trackPolylineRenderer!.trackUtility = self
    }

    func createPolylineRenderer(overlay: MKOverlay) -> MKPolylineRenderer {
        return TrackPolylineRenderer(overlay: overlay)
    }

    func switchRendererMode(rendererMode: RendererMode) -> Bool {
        if rendererMode == .fog {
            print("[Error]PolylineRenderer does not support fog mode!")
            return false
        }

        self.rendererMode = rendererMode

        return true
    }

    func updateDynamicTrack(coordinates: [CLLocationCoordinate2D]) {
        // Add the new polyline
        let newPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mkMapView!.addOverlay(newPolyline)

        // Remove the old polyline if need
        if let dynamicTrackPolyline = self.dynamicTrackPolyline {
            mkMapView!.removeOverlay(dynamicTrackPolyline)
        }

        dynamicTrackPolyline = newPolyline
    }

    private var newStaticTrackID: StaticTrackID {
        if staticPolylines.count == 0 {
            return 0
        } else {
            var id: StaticTrackID = 0
            while true {
                if staticPolylines.keys.contains(id) == false {
                    return id
                }

                id += 1
            }
        }
    }

    func addStaticTrackTrack(coordinates: [CLLocationCoordinate2D]) -> StaticTrackID {
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mkMapView!.addOverlay(polyline)

        let newStaticTrackID = self.newStaticTrackID
        staticPolylines[newStaticTrackID] = polyline

        return newStaticTrackID
    }

    func removeStaticTrack(staticTrackID: StaticTrackID) {
        if let polyline = staticPolylines[staticTrackID] {
            mkMapView!.removeOverlay(polyline)
            staticPolylines[staticTrackID] = nil
        }
    }

    func removeAllStaticTrack() {
        for (_, polyline) in staticPolylines {
            mkMapView!.removeOverlay(polyline)
        }

        staticPolylines.removeAll()
    }
}

fileprivate class TrackPolylineRenderer: MKPolylineRenderer {
    var trackUtility: TrackUtility?

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        // 线条的颜色
        strokeColor = UIColor.red
        // 线条的大小
        lineWidth = trackUtility!.lineWidth!

        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }
}
