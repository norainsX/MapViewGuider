//
//  FogLayer.swift
//  MapViewGuider
//
//  Created by norains on 2020/2/27.
//  Copyright © 2020 norains. All rights reserved.
//

import MapKit
import UIKit

class FogLayer: CALayer {
    var mapView: MKMapView?
    var path: UIBezierPath?

    lazy var displayLink: CADisplayLink = {
        let link = CADisplayLink(target: self, selector: #selector(self.updateDisplayLink))
        return link
    }()

    override func draw(in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        UIColor.darkGray.withAlphaComponent(0.75).setFill()
        UIColor.clear.setStroke()
        ctx.fill(UIScreen.main.bounds)
        ctx.setBlendMode(.clear)
        if let lineWidth = lineWidth {
            path?.lineWidth = lineWidth
        } else {
            path?.lineWidth = 5
        }

        path?.stroke()
        path?.fill()
        UIGraphicsPopContext()
    }

    @objc func updateDisplayLink() {
        if mapView == nil {
            // Do nothing
            return
        }

        let path = UIBezierPath()
        for overlay in mapView!.overlays {
            if let overlay = overlay as? MKPolyline {
                if let linePath = self.linePath(with: overlay) {
                    path.append(linePath)
                }
            }
        }

        path.lineJoinStyle = .round
        path.lineCapStyle = .round

        self.path = path
        setNeedsDisplay()
    }

    private func linePath(with overlay: MKPolyline) -> UIBezierPath? {
        if mapView == nil {
            return nil
        }

        let path = UIBezierPath()
        var points = [CGPoint]()
        for mapPoint in UnsafeBufferPointer(start: overlay.points(), count: overlay.pointCount) {
            let coordinate = mapPoint.coordinate
            let point = mapView!.convert(coordinate, toPointTo: mapView!)
            points.append(point)
        }

        if let first = points.first {
            path.move(to: first)
        }
        for point in points {
            path.addLine(to: point)
        }
        for point in points.reversed() {
            path.addLine(to: point)
        }

        path.close()

        return path
    }

    var lineWidth: CGFloat? {
        if let mapView = self.mapView {
            // The distance between mapPoint1 and mapPoint2 in the map is about 53m
            let mapPoint1 = CLLocationCoordinate2D(latitude: 22.629052, longitude: 114.136977)
            let mapPoint2 = CLLocationCoordinate2D(latitude: 22.629519, longitude: 114.137098)

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
}
