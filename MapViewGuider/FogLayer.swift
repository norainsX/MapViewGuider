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
        ctx.setStrokeColor(UIColor.red.cgColor)
        path?.lineWidth = 5
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
}
