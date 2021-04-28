//
//  BezierPath.swift
//  WorldRoad
//
//  Created by norains on 2021/2/3.
//  Copyright © 2021 norains. All rights reserved.
//

import MapKit

struct BezierPath {
    static func generateTrack(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()

        if let first = points.first {
            path.move(to: first)
        }
        for point in points {
            path.addLine(to: point)
        }
        for point in points.reversed() {
            path.addLine(to: point)
        }

        if points.count != 0 {
            path.close()
        }

        return path
    }

    static func generateCircle(arcCenter: CGPoint, radius: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: arcCenter,
                            radius: radius,
                            startAngle: CGFloat(0),
                            endAngle: CGFloat.pi * 2,
                            clockwise: true)
    }

    static func generateRectangle(startPoint: CGPoint, size: CGSize) -> UIBezierPath {
        let rect = CGRect(x: startPoint.x,
                          y: startPoint.y,
                          width: size.width,
                          height: size.height)
        return UIBezierPath(roundedRect: rect, cornerRadius: 0)
    }

    static func generateBubble(startPoint: CGPoint, size: CGSize, triangleHeight bottomMargin: CGFloat = 10, radius: CGFloat = 5) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineJoinStyle = .round

        /*
         //It's rectangle
         path.move(to: startPoint)
         path.addLine(to: CGPoint(x: startPoint.x + size.width, y: startPoint.y))
         path.addLine(to: CGPoint(x: startPoint.x + size.width, y: startPoint.y + size.height - bottomMargin))
         path.addLine(to: CGPoint(x: startPoint.x + (size.width + bottomMargin) / 2, y: startPoint.y + size.height - bottomMargin))
         path.addLine(to: CGPoint(x: startPoint.x + size.width / 2, y: startPoint.y + size.height))
         path.addLine(to: CGPoint(x: startPoint.x + (size.width - bottomMargin) / 2, y: startPoint.y + size.height - bottomMargin))
         path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y + size.height - bottomMargin))
         path.addLine(to: startPoint)
          */

        path.move(to: CGPoint(x: startPoint.x + radius, y: startPoint.y))
        path.addLine(to: CGPoint(x: startPoint.x + size.width - radius, y: startPoint.y))
        path.addArc(withCenter: CGPoint(x: startPoint.x + size.width - radius, y: startPoint.y + radius), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: startPoint.x + size.width, y: startPoint.y + size.height - bottomMargin - radius))
        path.addArc(withCenter: CGPoint(x: startPoint.x + size.width - radius, y: startPoint.y + size.height - bottomMargin - radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 0.5, clockwise: true)
        path.addLine(to: CGPoint(x: startPoint.x + (size.width + bottomMargin) / 2, y: startPoint.y + size.height - bottomMargin))
        path.addLine(to: CGPoint(x: startPoint.x + size.width / 2, y: startPoint.y + size.height))
        path.addLine(to: CGPoint(x: startPoint.x + (size.width - bottomMargin) / 2, y: startPoint.y + size.height - bottomMargin))
        path.addLine(to: CGPoint(x: startPoint.x + radius, y: startPoint.y + size.height - bottomMargin))
        path.addArc(withCenter: CGPoint(x: startPoint.x + radius, y: startPoint.y + size.height - bottomMargin - radius), radius: radius, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi, clockwise: true)
        path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y + radius))
        path.addArc(withCenter: CGPoint(x: startPoint.x + radius, y: startPoint.y + radius), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 1.5, clockwise: true)

        path.close()

        return path
    }
}
