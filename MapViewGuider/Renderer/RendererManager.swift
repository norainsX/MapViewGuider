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
        (trackRenderer as! RendererUtility).open()

        if rendererType == .layer {
            displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        }
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
        (trackRenderer as! RendererUtility).close()

        trackRenderer = RendererManager.createNewTrackRender(mkMapView: mkMapView, rendererType: rendererType)
        (trackRenderer as! RendererUtility).open()
    }

    private static func createNewTrackRender(mkMapView: MKMapView, rendererType: RendererType) -> TrackRenderer {
        if rendererType == .layer {
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
