//
//  location.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Khala
import CoreLocation
import Stem

@objc(MT_location) @objcMembers
class MT_location: NSObject, CLLocationManagerDelegate {
  
  func select(_ closure: @escaping KhalaClosure) {
    let vc = MTMapViewController(closure: closure)
    UIViewController.current?.st.push(vc: vc)
  }
  
  private lazy var manager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyKilometer
    manager.distanceFilter = 100
    manager.delegate = self
    manager.requestWhenInUseAuthorization()
    return manager
  }()
  
  private var fetchClosures = [KhalaClosure](){
    didSet{ checkStopUpdate() }
  }
  
  private var updatingClosures = [Int: KhalaClosure](){
    didSet{ checkStopUpdate() }
  }
  
  private var headingClosures = [Int: KhalaClosure](){
    didSet{ checkStopUpdate() }
  }
  
  /// 单次定位
  func fetch(_ closure: @escaping KhalaClosure) {
    guard CLLocationManager.locationServicesEnabled() else {
      closure(["error": "locationServicesEnabled is false"])
      return
    }
    self.fetchClosures.append(closure)
    self.manager.requestLocation()
  }
  
  /// 持续更新定位
  func updating(_ info: [String: Any], closure: @escaping KhalaClosure) {
    guard let label = info["label"] as? Int else {
      closure(["error": "缺少标识"])
      return
    }
    self.updatingClosures[label] = closure
    self.manager.startUpdatingLocation()
    
    ///  优先返回上次定位结果
    if let item = self.manager.location {
      let result = [
        "alt": item.altitude,
        "lat": item.coordinate.latitude,
        "lng": item.coordinate.longitude
      ]
      closure(result)
    }
    
  }
  
  /// 移除定位更新
  func stopUpdate(_ info: [String: Any]) -> [String: Any] {
    guard let label = info["label"] as? Int else {
      return ["error": "缺少标识"]
    }
    self.updatingClosures[label] = nil
    return [:]
  }
  
  /// 移除所有的定位更新
  func stopAllUpdates() -> [String: Any] {
    self.updatingClosures.removeAll()
    return [:]
  }
  
  /// 持续更新罗盘
  func updatingHeading(_ info: [String: Any], closure: @escaping KhalaClosure) {
    guard CLLocationManager.headingAvailable() else {
      closure(["error": "not support heading"])
      return
    }

    guard let label = info["label"] as? Int else {
      closure(["error": "缺少标识"])
      return
    }
    self.headingClosures[label] = closure
    self.manager.startUpdatingHeading()
  }
  
  /// 移除罗盘更新
  func stopHeadingUpdate(_ info: [String: Any]) -> [String: Any] {
    guard let label = info["label"] as? Int else {
      return ["error": "缺少标识"]
    }
    self.headingClosures[label] = nil
    return [:]
  }
  
  /// 移除所有的罗盘更新
  func stopAllHeadingUpdate() -> [String: Any] {
    self.headingClosures.removeAll()
    return [:]
  }
  
}

extension MT_location {
  
  private func checkStopUpdate() {
    if self.fetchClosures.isEmpty, CLLocationManager.significantLocationChangeMonitoringAvailable() {
      self.manager.stopMonitoringSignificantLocationChanges()
    }
    
    if self.updatingClosures.isEmpty {
      self.manager.stopUpdatingLocation()
    }
    
    if self.headingClosures.isEmpty {
      self.manager.stopUpdatingHeading()
    }
  }

  private func checkStartUpdate() {
    if !self.fetchClosures.isEmpty {
      if CLLocationManager.significantLocationChangeMonitoringAvailable() {
        self.manager.startMonitoringSignificantLocationChanges()
      }else {
        self.manager.startUpdatingLocation()
      }
    }
    
    if !self.updatingClosures.isEmpty {
      self.manager.startUpdatingLocation()
    }
    
    if !self.headingClosures.isEmpty {
      self.manager.startUpdatingHeading()
    }
  }

  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      self.checkStartUpdate()
    default:
      break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let item = locations.first else { return }
    let result = [
      "alt": item.altitude,
      "lat": item.coordinate.latitude,
      "lng": item.coordinate.longitude
    ]
    
    self.fetchClosures.forEach { (closure) in
      closure(result)
    }
    self.fetchClosures.removeAll()
    self.updatingClosures.forEach { (element) in
      element.value(result)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    let result = [ "error": error.localizedDescription ]
    
    self.fetchClosures.forEach { (closure) in
      closure(result)
    }
    self.fetchClosures.removeAll()
    self.updatingClosures.forEach { (element) in
      element.value(result)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    let result = ["magneticHeading": newHeading.magneticHeading,
                  "trueHeading": newHeading.trueHeading,
                  "headingAccuracy": newHeading.headingAccuracy,
                  "x": newHeading.x,
                  "y": newHeading.y,
                  "z": newHeading.z]
    
    self.headingClosures.forEach { (element) in
      element.value(result)
    }
  }
}
