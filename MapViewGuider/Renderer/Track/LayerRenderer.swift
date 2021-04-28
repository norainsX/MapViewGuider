//
//  LayerRenderer.swift
//  WorldRoad
//
//  Created by norains on 2021/04/25.
//  Copyright © 2019 norains. All rights reserved.
//

import MapKit

class LayerRenderer: TrackUtility, TrackRenderer {
    private var rendererMode = RendererMode.clear
    private var trackLayer = TrackLayer()

    override init(mkMapView: MKMapView) {
        super.init(mkMapView: mkMapView)
        trackLayer.layerRenderer = self
    }

    var CALayer: CALayer? {
        return trackLayer
    }

    func switchRendererMode(rendererMode: RendererMode) -> Bool {
        self.rendererMode = rendererMode
        return true
    }

    func updateDynamicTrack(coordinates: [CLLocationCoordinate2D]) {
    }

    func addStaticTrackTrack(coordinates: [CLLocationCoordinate2D]) -> StaticTrackID {
        return 0
    }

    func removeStaticTrack(staticTrackID: StaticTrackID) {
    }

    func removeAllStaticTrack() {
    }
}

class TrackLayer: CALayer {
    var mode = RendererMode.fog

    var layerRenderer: LayerRenderer?

    var tracks: [[CLLocationCoordinate2D]]? {
        nil
    }

    var fogColor: UIColor {
        UIColor.darkGray
    }

    var trackColor: UIColor {
        UIColor.red
    }

    var mapView: MKMapView?

    private var trackBezierPath: UIBezierPath?

    // MARK: - CALayer

    override func draw(in ctx: CGContext) {
        if let mapView = self.mapView {
            UIGraphicsPushContext(ctx)

            if mode == .fog {
                fogColor.withAlphaComponent(0.75).setFill()
                UIColor.clear.setStroke()
                ctx.fill(mapView.frame)
                ctx.setBlendMode(.clear)
            } else if mode == .clear {
                ctx.setStrokeColor(trackColor.withAlphaComponent(0.5).cgColor)
            }

            if let lineWidth = layerRenderer?.lineWidth {
                trackBezierPath?.lineWidth = lineWidth
            }
            trackBezierPath?.stroke()
            trackBezierPath?.fill()

            UIGraphicsPopContext()
        }
    }

    // MARK: - CADisplayLink

    lazy var displayLink: CADisplayLink = {
        let link = CADisplayLink(target: self, selector: #selector(self.updateDisplayLink))
        return link
    }()

    @objc func updateDisplayLink() {
        if mapView == nil {
            // Do nothing
            return
        }

        // Track
        let trackBezierPath = UIBezierPath()

        if let tracks = self.tracks {
            for coordinates in tracks {
                trackBezierPath.append(generateTrack(coordinates: coordinates))
            }
        }

        trackBezierPath.lineJoinStyle = .round
        trackBezierPath.lineCapStyle = .round
        self.trackBezierPath = trackBezierPath

        setNeedsDisplay()
    }

    func generateTrack(coordinates: [CLLocationCoordinate2D]) -> UIBezierPath {
        let points = reducePoint(coordinates: coordinates)
        return BezierPath.generateTrack(points: points)
    }

    func generateCircle(coordinate: CLLocationCoordinate2D, radius: CGFloat) -> UIBezierPath? {
        if let mapView = self.mapView {
            let point = mapView.convert(coordinate, toPointTo: mapView)
            return BezierPath.generateCircle(arcCenter: point, radius: radius)
        } else {
            return nil
        }
    }

    func reducePoint(coordinates: [CLLocationCoordinate2D]) -> [CGPoint] {
        var points = [CGPoint]()

        for coordinate in coordinates {
            if let point = checkValidNewPoint(points: points, coordinate: coordinate) {
                points.append(point)
            }
        }

        return points
    }

    func checkValidNewPoint(points: [CGPoint], coordinate: CLLocationCoordinate2D) -> CGPoint? {
        if let mapView = self.mapView {
            let point = mapView.convert(coordinate, toPointTo: mapView)
            if points.count == 0 {
                return point
            } else {
                let pixelDistance = sqrt(pow(points[points.count - 1].x - point.x, 2) + pow(points[points.count - 1].y - point.y, 2))
                // If the distance less than 1 pixel, it needn't to draw
                if pixelDistance >= 1 {
                    return point
                }
            }
        }
        return nil
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
