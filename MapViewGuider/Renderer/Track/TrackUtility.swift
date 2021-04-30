//
//  TrackUtility.swift
//  MapViewGuider
//
//  Created by norains on 2021/4/28.
//  Copyright © 2021 norains. All rights reserved.
//

import MapKit

class TrackUtility {
    private(set) var mkMapView: MKMapView?

    init(mkMapView: MKMapView) {
        self.mkMapView = mkMapView
    }
    
    @discardableResult func open() -> Bool{
        return true
    }
    
    func close(){
        
    }

    var lineWidth: CGFloat? {
        if let mkMapView = self.mkMapView {
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

            let viewPoint1 = mkMapView.convert(mapPoint1, toPointTo: mkMapView)
            let viewPoint2 = mkMapView.convert(mapPoint2, toPointTo: mkMapView)

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

    private var _fogColor: UIColor = UIColor.darkGray
    var fogColor: UIColor {
        get {
            return _fogColor.withAlphaComponent(0.75)
        }
        set {
            _fogColor = newValue
        }
    }

    private var _trackColor: UIColor = UIColor.red
    var trackColor: UIColor {
        get {
            return _trackColor.withAlphaComponent(0.5)
        }
        set {
            _trackColor = newValue
        }
    }
}
