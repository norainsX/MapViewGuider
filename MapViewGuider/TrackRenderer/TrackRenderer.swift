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

    @discardableResult func open() -> Bool
    func close() 

    var MKPolylineRenderer: MKPolylineRenderer? {
        get 
    }

    var CALayer: CALayer? {
        get
    }

    func updateDynamicTrack(coordinates: [CLLocationCoordinate2D]) 

    typealias StaticTrackID = Int
    func addStaticTrackTrack(coordinates: [CLLocationCoordinate2D]) -> StaticTrackID 
    func removeStaticTrack(staticTrackID: StaticTrackID) 
    func removeAllStaticTrack() 
    
}

extension TrackRenderer {
    var MKPolylineRenderer: MKPolylineRenderer? {
        return nil 
    }

    var CALayer: CALayer? {
        return nil 
    }

    func open() -> Bool{
        return true
    }

    func close() {
        // Do nothing
    }
    
}