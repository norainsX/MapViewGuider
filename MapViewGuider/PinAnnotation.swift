//
//  PinAnnotation.swift
//  MapViewGuider
//
//  Created by norains on 2020/2/27.
//  Copyright © 2020 norains. All rights reserved.
//

import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    func makeTextAccessoryView(annotationView: MKPinAnnotationView) {
        var accessoryView: UIView

        //创建文本的附属视图
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        textView.text = "Hello, PinAnnotation!"
        textView.isEditable = false
        accessoryView = textView

        //设置文本对齐的约束条件
        let widthConstraint = NSLayoutConstraint(item: accessoryView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        accessoryView.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: accessoryView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        accessoryView.addConstraint(heightConstraint)
        
        //将创建好的附属视图赋值
        annotationView.detailCalloutAccessoryView = accessoryView
        
        //让附属视图可以显示
        annotationView.canShowCallout = true
    }
}
