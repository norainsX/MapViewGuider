//
//  PolylineRenderer.swift
//  WorldRoad
//
//  Created by norains on 2021/04/25.
//  Copyright © 2019 norains. All rights reserved.
//
import MapKit

class PolylineRenderer: TrackUtility, TrackRenderer {
    private var dynamicTrack: MKPolyline?
    private var staticTracks = [StaticTrackID: MKPolyline]()
    private var rendererMode = RendererMode.clear

    func createPolylineRenderer(overlay: MKOverlay) -> MKPolylineRenderer {
        let trackPolylineRenderer = TrackPolylineRenderer(overlay: overlay)
        trackPolylineRenderer.trackUtility = self
        return trackPolylineRenderer
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
        if let dynamicTrack = self.dynamicTrack {
            mkMapView!.removeOverlay(dynamicTrack)
        }

        dynamicTrack = newPolyline
    }

    private var newStaticTrackID: StaticTrackID {
        if staticTracks.count == 0 {
            return 0
        } else {
            var id: StaticTrackID = 0
            while true {
                if staticTracks.keys.contains(id) == false {
                    return id
                }

                id += 1
            }
        }
    }

    func addStaticTrack(coordinates: [CLLocationCoordinate2D]) -> StaticTrackID {
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mkMapView!.addOverlay(polyline)

        let newID = self.newStaticTrackID
        staticTracks[newID] = polyline

        return newID
    }

    func removeStaticTrack(staticTrackID: StaticTrackID) {
        if let polyline = staticTracks[staticTrackID] {
            mkMapView!.removeOverlay(polyline)
            staticTracks[staticTrackID] = nil
        }
    }

    func removeAllStaticTrack() {
        for (_, polyline) in staticTracks {
            mkMapView!.removeOverlay(polyline)
        }

        staticTracks.removeAll()
    }
}

fileprivate class TrackPolylineRenderer: MKPolylineRenderer {
    var trackUtility: TrackUtility?

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        // 线条的颜色
        strokeColor = trackUtility?.trackColor
        // 线条的大小
        lineWidth = trackUtility!.lineWidth!

        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }
}
