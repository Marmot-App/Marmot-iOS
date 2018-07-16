//
//  location.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/16.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreLocation
import SPRoutable
@objc(Router_location)

class LocationHelper: NSObject,CLLocationManagerDelegate {
  
  var updatesBlocks: [RoutableBlock] = []
  var fetchBlocks: [RoutableBlock] = []
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let item = locations.first else {
      return
    }
    let res = ["lat": item.coordinate.latitude,
               "lng": item.coordinate.longitude,
               "alt": item.altitude,
               "horizontalAccuracy": item.horizontalAccuracy,
               "course": item.course,
               "timestamp": item.timestamp] as [String : Any]
    
    
    
    
    
    fetchBlocks.forEach { (item) in
      item(res)
    }
    fetchBlocks.removeAll()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
  
}

class Router_location: NSObject {
  
  lazy var helper: LocationHelper = {
    return LocationHelper()
  }()
  
  lazy var manager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = helper
    manager.requestWhenInUseAuthorization()
    return manager
  }()
  
  @objc func router_fetch(block: @escaping RoutableBlock) {
    helper.fetchBlocks.append(block)
    if #available(iOS 9.0, *) {
      manager.requestLocation()
    } else {
      manager.startUpdatingLocation()
    }
    return
  }
  
}
