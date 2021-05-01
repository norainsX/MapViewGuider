//
//  LocationRenderer.swift
//  MapViewGuider
//
//  Created by norains on 2021/4/30.
//  Copyright © 2021 norains. All rights reserved.
//

import MapKit

class LocationRenderer: RendererUtility {
    
    @discardableResult func open() -> Bool {
        coordinateLayer!.frame = UIScreen.main.bounds
        coordinateLayer!.mkMapView!.layer.addSublayer(coordinateLayer!)
        return true
    }

    func close() {
        coordinateLayer!.mkMapView!.layer.removeFromSuperlayer()
    }

    private var coordinateLayer: CoordinateLayer?

    init(mkMapView: MKMapView, rendererMode: RendererMode) {
        coordinateLayer = CoordinateLayer()
        coordinateLayer!.mkMapView = mkMapView
        coordinateLayer!.rendererMode = rendererMode
    }

    func updateCoordinate(coordinate: CLLocationCoordinate2D) {
        coordinateLayer!.coordinate = coordinate
    }

    func onUpdateDisplayLink() {
        coordinateLayer!.onUpdateDisplayLink()
    }

    func switchRendererMode(rendererMode: RendererMode) -> Bool {
        coordinateLayer!.rendererMode = rendererMode
        return true
    }
}

fileprivate class CoordinateLayer: CALayer {
    var rendererMode: RendererMode = .clear

    var mkMapView: MKMapView?
    var coordinate: CLLocationCoordinate2D?

    private var locationMarkReverseIndex = false
    private let locationMarkMinIndex: CGFloat = 0
    private let locationMarkMaxIndex: CGFloat = 120
    private var locationMarkHoldStartIndex: CGFloat {
        locationMarkMaxIndex * 0.7
    }

    private var locationMarkIndex: CGFloat = 0
    private let locationMarkOutlineRadius: CGFloat = 12.0
    var locationMarkInnerRadius: CGFloat = 0
    private var locationMarkMinInnerRadius: CGFloat {
        locationMarkOutlineRadius * 0.6
    }

    private var locationMarkMaxInnerRadius: CGFloat {
        locationMarkOutlineRadius * 0.8
    }

    private var locationMarkOutlineBezierPath: UIBezierPath?
    private var locationMarkInnerBezierPath: UIBezierPath?

    private func generateLocationMarkNextFrame(coordinate: CLLocationCoordinate2D) -> (locationMarkOutlineBezierPath: UIBezierPath?, locationMarkInnerBezierPath: UIBezierPath?) {
        if locationMarkReverseIndex == false {
            if locationMarkIndex >= locationMarkHoldStartIndex {
                // Use the last locationMarkInnerRadius value and do nothing
            } else {
                locationMarkInnerRadius = (locationMarkMaxInnerRadius - locationMarkMinInnerRadius) / CGFloat(locationMarkMaxIndex - locationMarkMinIndex) * (locationMarkIndex - locationMarkMinIndex) + locationMarkMinInnerRadius
            }

            locationMarkIndex += 1
            if locationMarkIndex > locationMarkMaxIndex {
                locationMarkIndex = locationMarkHoldStartIndex
                locationMarkReverseIndex = true
            }
        } else {
            locationMarkInnerRadius = (locationMarkMaxInnerRadius - locationMarkMinInnerRadius) / CGFloat(locationMarkMaxIndex - locationMarkMinIndex) * (locationMarkIndex - locationMarkMinIndex) + locationMarkMinInnerRadius

            locationMarkIndex -= 1
            if locationMarkIndex < locationMarkMinIndex {
                locationMarkIndex = locationMarkMinIndex
                locationMarkReverseIndex = false
            }
        }

        let locationMarkInnerBezierPath = generateCircle(coordinate: coordinate, radius: locationMarkInnerRadius)
        let locationMarkOutlineBezierPath = generateCircle(coordinate: coordinate, radius: locationMarkOutlineRadius)

        return (locationMarkOutlineBezierPath, locationMarkInnerBezierPath)
    }

    override func draw(in ctx: CGContext) {
        UIGraphicsPushContext(ctx)

        if rendererMode == .fog {
            ctx.setBlendMode(.clear)
            locationMarkOutlineBezierPath?.stroke()
            locationMarkOutlineBezierPath?.fill()
        }

        let outlineColor: CGColor = UIColor.white.cgColor
        let innerColor: CGColor = UIColor(red: 0.036, green: 0.518, blue: 0.996, alpha: 1.0).cgColor

        ctx.setBlendMode(.normal)

        ctx.setStrokeColor(outlineColor)
        ctx.setFillColor(outlineColor)
        locationMarkOutlineBezierPath?.stroke()
        locationMarkOutlineBezierPath?.fill()

        ctx.setStrokeColor(innerColor)
        ctx.setFillColor(innerColor)
        locationMarkInnerBezierPath?.stroke()
        locationMarkInnerBezierPath?.fill()

        UIGraphicsPopContext()
    }

    private func generateCircle(coordinate: CLLocationCoordinate2D, radius: CGFloat) -> UIBezierPath? {
        if let mkMapView = self.mkMapView {
            let point = mkMapView.convert(coordinate, toPointTo: mkMapView)
            return BezierPath.generateCircle(arcCenter: point, radius: radius)
        } else {
            return nil
        }
    }

    // MARK: - CADisplayLink

    func onUpdateDisplayLink() {
        if let coordinate = self.coordinate {
            let result = generateLocationMarkNextFrame(coordinate: coordinate)
            locationMarkInnerBezierPath = result.locationMarkInnerBezierPath
            locationMarkOutlineBezierPath = result.locationMarkOutlineBezierPath

            setNeedsDisplay()
        }
    }
}
