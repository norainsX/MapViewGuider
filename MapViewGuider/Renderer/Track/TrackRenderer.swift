//
//  TrackRenderer.swift
//  WorldRoad
//
//  Created by norains on 2021/04/26.
//  Copyright © 2019 norains. All rights reserved.
//

import MapKit

enum RendererMode: Int, CaseIterable, Codable {
    case clear
    case fog

    var localizedDescription: String {
        switch self {
        case .clear:
            return NSLocalizedString("Clear", comment: "")
        case .fog:
            return NSLocalizedString("Fog", comment: "")
        }
    }
}

protocol TrackRenderer {
    @discardableResult func switchRendererMode(rendererMode: RendererMode) -> Bool

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
}

extension TrackRenderer {
    func createPolylineRenderer(overlay: MKOverlay) -> MKPolylineRenderer {
        return MKPolylineRenderer()
    }

    var CALayer: CALayer? {
        return nil
    }
}
