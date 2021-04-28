//
//  LayerRenderer.swift
//  WorldRoad
//
//  Created by norains on 2021/04/25.
//  Copyright © 2019 norains. All rights reserved.
//

import MapKit

class LayerRenderer: TrackRenderer {
    private var rendererMode = RendererMode.clear
    private var mkMapView: MKMapView
    private var _caLayer = _CALayer()
    

    init(mkMapView: MKMapView) {
        self.mkMapView = mkMapView
    }
    
    var CALayer: CALayer? {
        return _caLayer
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

fileprivate class _CALayer: CALayer {
    var mode = RendererMode.fog

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

            if let lineWidth = lineWidth {
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

    var lineWidth: CGFloat? {
        if let mapView = self.mapView {
            // The distance between mapPoint1 and mapPoint2 in the map is about 53m
            // let mapPoint1 = CLLocationCoordinate2D(latitude: 22.629052, longitude: 114.136977)
            // let mapPoint2 = CLLocationCoordinate2D(latitude: 22.629519, longitude: 114.137098)

            // The distance between mapPoint1 and mapPoint2 in the map is about 25m
            // let mapPoint1 = CLLocationCoordinate2D(latitude: 22.629052, longitude: 114.136977)
            // let mapPoint2 = CLLocationCoordinate2D(latitude: 22.629250, longitude: 114.137098)

            // The distance between mapPoint1 and mapPoint2 in the map is about 28m
            let mapPoint1 = CLLocationCoordinate2D(latitude: 22.629052, longitude: 114.136977)
            let mapPoint2 = CLLocationCoordinate2D(latitude: 22.629180, longitude: 114.137098)

            // print(LocationUtils.coordinateDistance(mapPoint1, mapPoint2))

            let viewPoint1 = mapView.convert(mapPoint1, toPointTo: mapView)
            let viewPoint2 = mapView.convert(mapPoint2, toPointTo: mapView)

            let distance = sqrt(pow(viewPoint1.x - viewPoint2.x, 2) + pow(viewPoint1.y - viewPoint2.y, 2))
            if distance < 1 {
                return 1.0
            } else {
                return CGFloat(distance)
            }

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
