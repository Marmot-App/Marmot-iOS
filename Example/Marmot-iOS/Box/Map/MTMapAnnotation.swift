//
//  MTMapAnnotationView.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/20.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MapKit

class MTMapAnnotation: NSObject, MKAnnotation {
  
  var title: String? = nil
  var subtitle: String? = nil
  var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.init()
  
  convenience init(title: String, subtitle: String,coordinate: CLLocationCoordinate2D) {
    self.init()
    self.title = title
    self.subtitle = subtitle
    self.coordinate = coordinate
  }
}
