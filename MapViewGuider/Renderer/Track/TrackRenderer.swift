//
//  TrackRenderer.swift
//  WorldRoad
//
//  Created by norains on 2021/04/26.
//  Copyright © 2019 norains. All rights reserved.
//

import MapKit



protocol TrackRenderer {
    func createPolylineRenderer(overlay: MKOverlay) -> MKPolylineRenderer

    var fogColor: UIColor {
        get
        set
    }

    var trackColor: UIColor {
        get
        set
    }

    func updateDynamicTrack(coordinates: [CLLocationCoordinate2D])

    typealias StaticTrackID = Int
    @discardableResult func addStaticTrack(coordinates: [CLLocationCoordinate2D]) -> StaticTrackID
    func removeStaticTrack(staticTrackID: StaticTrackID)
    func removeAllStaticTrack()

    // For the layer renderer only

    func onUpdateDisplayLink()
}

extension TrackRenderer {
    func createPolylineRenderer(overlay: MKOverlay) -> MKPolylineRenderer {
        return MKPolylineRenderer()
    }

    func onUpdateDisplayLink() {
    }
}
