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
  
 static var copyManager: CLLocationManager {
    let manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyKilometer
    manager.distanceFilter = 100
    manager.requestWhenInUseAuthorization()
    return manager
  }
  
  lazy var helper: LocationHelper = {
    return LocationHelper()
  }()
  
  lazy var manager: CLLocationManager = {
    let manager = Router_location.copyManager
    manager.delegate = helper
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
    let itemBlock: RoutableBlock = block
    helper.updatesBlocks.append(itemBlock)
    manager.startUpdatingLocation()
  }
  
  /// 监听地理位置变化
  @objc func router_stopUpdates() {
    helper.fetchBlocks.removeAll()
    helper.updatesBlocks.removeAll()
    manager.stopUpdatingLocation()
  }
  
  @objc func router_select(block: @escaping RoutableBlock) {
    let vc = MTMapViewController()
    UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
  }
  
  /// 监听罗盘数据变化
  @objc func router_trackHeading(block: @escaping RoutableBlock) {
    manager.startUpdatingHeading()
  }
  
  
}
