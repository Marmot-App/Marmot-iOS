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
class LocationHelper: NSObject,CLLocationManagerDelegate {
  
  var updatesBlocks: [RoutableBlock] = []
  var fetchBlocks: [RoutableBlock] = []
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let item = locations.last else {
      return
    }
    let res = ["lat": item.coordinate.latitude,
               "lng": item.coordinate.longitude,
               "alt": item.altitude,
               "horizontalAccuracy": item.horizontalAccuracy,
               "course": item.course,
               "timestamp": item.timestamp] as [String : Any]
    
    updatesBlocks.forEach { (item) in
      item(res)
    }
    fetchBlocks.forEach { (item) in
      item(res)
    }
    fetchBlocks.removeAll()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
  
}

@objc(Router_location)
class Router_location: NSObject {
  
  lazy var helper: LocationHelper = {
    return LocationHelper()
  }()
  
  lazy var manager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = helper
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.distanceFilter = 10
    manager.requestWhenInUseAuthorization()
    return manager
  }()
  
  /// 获取地理位置
  @objc func router_fetch(block: @escaping RoutableBlock) {
    let itemBlock: RoutableBlock = {[weak self] (item) in
      block(item)
      guard let base = self else { return }
      if base.helper.updatesBlocks.isEmpty {
        base.manager.stopUpdatingLocation()
      }else{
        base.manager.startUpdatingLocation()
      }
    }
    helper.fetchBlocks.append(itemBlock)
    if #available(iOS 9.0, *) {
      manager.stopUpdatingLocation()
      manager.requestLocation()
    } else {
      manager.startUpdatingLocation()
    }
  }
  
  /// 监听地理位置变化
  @objc func router_startUpdates(block: @escaping RoutableBlock) {
    let itemBlock: RoutableBlock = { (item) in
      var item = item
      item["isListen"] = true
      block(item)
    }
    helper.updatesBlocks.append(itemBlock)
    
    
    
    // manager.startUpdatingLocation()
  }
  
  /// 监听地理位置变化
  @objc func router_stopUpdates() {
    helper.fetchBlocks.removeAll()
    helper.updatesBlocks.removeAll()
    manager.stopUpdatingLocation()
  }
  
  /// 监听罗盘数据变化
  @objc func router_trackHeading(block: @escaping RoutableBlock) {
    manager.startUpdatingHeading()
  }
  
  
}
