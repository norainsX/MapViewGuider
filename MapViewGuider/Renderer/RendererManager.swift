//
//  RendererManager.swift
//  WorldRoad
//
//  Created by norains on 2021/04/25.
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

class RendererManager {
    private var mkMapView: MKMapView
    private(set) var trackRenderer: TrackRenderer
    private(set) var locationRenderer: LocationRenderer
    private var trackRendererType: TrackRendererType
    private var rendererMode: RendererMode

    init(mkMapView: MKMapView, rendererMode: RendererMode = .clear, trackRendererType: TrackRendererType = .polyline) {
        self.mkMapView = mkMapView
        self.trackRendererType = trackRendererType
        self.rendererMode = rendererMode

        trackRenderer = RendererManager.createNewTrackRender(mkMapView: mkMapView, trackRendererType: trackRendererType)
        (trackRenderer as! RendererUtility).open()

        locationRenderer = LocationRenderer(mkMapView: mkMapView, rendererMode: rendererMode)
        locationRenderer.open()

        if trackRendererType == .layer {
            displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        }
    }

    enum TrackRendererType: Int {
        case polyline
        case layer
    }

    func switchTrackRenderer(trackRendererType: TrackRendererType) {
        if self.trackRendererType == trackRendererType {
            // Do nothing
            return
        }

        // Release the resource
        (trackRenderer as! RendererUtility).close()

        trackRenderer = RendererManager.createNewTrackRender(mkMapView: mkMapView, trackRendererType: trackRendererType)
        (trackRenderer as! RendererUtility).open()
    }

    private static func createNewTrackRender(mkMapView: MKMapView, trackRendererType: TrackRendererType) -> TrackRenderer {
        if trackRendererType == .layer {
            return LayerRenderer(mkMapView: mkMapView)
        } else {
            return PolylineRenderer(mkMapView: mkMapView)
        }
    }

    // MARK: - CADisplayLink

    lazy var displayLink: CADisplayLink = {
        let link = CADisplayLink(target: self, selector: #selector(self.updateDisplayLink))
        return link
    }()

    @objc func updateDisplayLink() {
        trackRenderer.onUpdateDisplayLink()
        locationRenderer.onUpdateDisplayLink()
    }

    private var debouncer: Debouncer?
    func adjustPreferredFramesPerSecond() {
        let adjustDelay = 30 * 1000 // 30s
        displayLink.preferredFramesPerSecond = 0

        if debouncer == nil {
            debouncer = Debouncer(delayMilliseconds: adjustDelay) {
                self.displayLink.preferredFramesPerSecond = 1
            }
        }

        debouncer?.restart()
    }
}
