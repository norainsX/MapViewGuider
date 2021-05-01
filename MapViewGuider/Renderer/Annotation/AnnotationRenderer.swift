//
//  AnnotationRenderer.swift
//  MapViewGuider
//
//  Created by norains on 2021/4/28.
//  Copyright © 2021 norains. All rights reserved.
//

import MapKit

class AnnotationRenderer {
    /*
    struct Rectangle {
        var landmarkID: Landmark.ID
        var coordinate: CLLocationCoordinate2D
        var size: CGSize
    }

    func generateRectangle(rectangle: Rectangle) -> UIBezierPath? {
        if let mapView = self.mapView {
            let point = mapView.convert(rectangle.coordinate, toPointTo: mapView)
            let startPoint = CGPoint(x: point.x - rectangle.size.width / 2,
                                     y: point.y - rectangle.size.height / 2)
            return BezierPath.generateRectangle(startPoint: startPoint, size: rectangle.size)
        } else {
            return nil
        }
    }

    func generateBubble(rectangle: Rectangle) -> (startPoint: CGPoint, path: UIBezierPath)? {
        if let mapView = self.mapView {
            let point = mapView.convert(rectangle.coordinate, toPointTo: mapView)
            let startPoint = CGPoint(x: point.x - rectangle.size.width / 2,
                                     y: point.y - rectangle.size.height / 2)
            return (startPoint, BezierPath.generateBubble(startPoint: startPoint, size: rectangle.size))
        } else {
            return nil
        }
    }
 */
}
