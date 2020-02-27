//
//  PolylineRenderer.swift
//  MapViewGuider
//
//  Created by norains on 2020/2/27.
//  Copyright © 2020 norains. All rights reserved.
//

import Foundation
import MapKit

class PolylineRenderer: MKPolylineRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        // 线条的颜色
        strokeColor = UIColor.red
        // 线条的大小
        lineWidth = 5
        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }
}
