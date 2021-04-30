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
    private var trackLayer: TrackLayer?

    override init(mkMapView: MKMapView) {
        super.init(mkMapView: mkMapView)

        trackLayer = TrackLayer()
        trackLayer!.trackUtility = self
        trackLayer!.mkMapView = mkMapView
    }

    override func open() -> Bool {
        super.open()

        trackLayer!.frame = UIScreen.main.bounds
        mkMapView!.layer.addSublayer(trackLayer!)
        return true
    }

    override func close() {
        super.close()

        mkMapView!.layer.removeFromSuperlayer()
    }

    func onUpdateDisplayLink() {
        trackLayer?.onUpdateDisplayLink()
    }

    override func switchRendererMode(rendererMode: RendererMode) -> Bool {
        self.rendererMode = rendererMode
        trackLayer!.rendererMode = rendererMode
        return true
    }

    func updateDynamicTrack(coordinates: [CLLocationCoordinate2D]) {
        trackLayer!.dynamicTracks = coordinates
    }

    func addStaticTrack(coordinates: [CLLocationCoordinate2D]) -> StaticTrackID {
        let newID = newStaticTrackID
        trackLayer!.staticTracks[newID] = coordinates
        return newID
    }

    func removeStaticTrack(staticTrackID: StaticTrackID) {
        trackLayer!.staticTracks[staticTrackID] = nil
    }

    func removeAllStaticTrack() {
        trackLayer!.staticTracks.removeAll()
    }

    private var newStaticTrackID: StaticTrackID {
        if trackLayer!.staticTracks.count == 0 {
            return 0
        } else {
            var id: StaticTrackID = 0
            while true {
                if trackLayer!.staticTracks.keys.contains(id) == false {
                    return id
                }

                id += 1
            }
        }
    }
}

fileprivate class TrackLayer: CALayer {
    var rendererMode = RendererMode.fog

    var trackUtility: TrackUtility?

    // var staticTracks: [[CLLocationCoordinate2D]]?
    var staticTracks = [TrackRenderer.StaticTrackID: [CLLocationCoordinate2D]]()
    var dynamicTracks: [CLLocationCoordinate2D]?

    var mkMapView: MKMapView?

    private var trackBezierPath: UIBezierPath?

    // MARK: - CALayer

    override func draw(in ctx: CGContext) {
        if let mapView = mkMapView {
            UIGraphicsPushContext(ctx)

            if rendererMode == .fog {
                trackUtility!.fogColor.setFill()
                UIColor.clear.setStroke()
                ctx.fill(mapView.frame)
                ctx.setBlendMode(.clear)
            } else if rendererMode == .clear {
                ctx.setStrokeColor(trackUtility!.trackColor.cgColor)
            }

            if let lineWidth = trackUtility?.lineWidth {
                trackBezierPath?.lineWidth = lineWidth
            }
            trackBezierPath?.stroke()
            trackBezierPath?.fill()

            UIGraphicsPopContext()
        }
    }

    // MARK: - CADisplayLink

    func onUpdateDisplayLink() {
        if mkMapView == nil {
            // Do nothing
            return
        }

        // Track
        let trackBezierPath = UIBezierPath()

        for (_, coordinates) in staticTracks {
            trackBezierPath.append(generateTrack(coordinates: coordinates))
        }

        if let coordinates = dynamicTracks {
            trackBezierPath.append(generateTrack(coordinates: coordinates))
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
        if let mapView = mkMapView {
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
        if let mapView = mkMapView {
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
}
