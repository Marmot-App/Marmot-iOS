//
//  File.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/6.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@objc(Router_device)
class Router_device: NSObject {
  
  @objc func router_info() -> [String:Any] {
    let device = UIDevice.current
    let screen = UIScreen.main
    
    
    var dict = ["name": device.name,
                "model": device.model,
                // "localizedModel": device.localizedModel,
      // "systemName": device.systemName,
      // "identifierForVendor": device.identifierForVendor?.description ?? "",
      // "isGeneratingDeviceOrientationNotifications": device.isGeneratingDeviceOrientationNotifications,
      // "isMultitaskingSupported": device.isMultitaskingSupported,
      // "proximityState": device.proximityState,
      // "userInterfaceIdiom": device.userInterfaceIdiom.rawValue,
      // "isProximityMonitoringEnabled": device.isProximityMonitoringEnabled
      "systemVersion": device.systemVersion] as [String : Any]
    
    
    
    dict["screen"] = ["width": screen.bounds.size.width,
                      "height": screen.bounds.size.height,
                      "scale": screen.scale,
                      "orientation": device.orientation.rawValue]
    
    dict["language"] = NSLocale.preferredLanguages.first ?? ""
    
    dict["battery"] = [
      "level": device.batteryLevel,
      "state": device.batteryState.rawValue
      //      "isBatteryMonitoringEnabled": device.isBatteryMonitoringEnabled
    ]
    
    return dict
    
    //    open func beginGeneratingDeviceOrientationNotifications() // nestable
    //    open func endGeneratingDeviceOrientationNotifications()
    //    open func playInputClick()
  }
  
  @objc func router_id() -> String {
    return UIDevice.current.name
  }
  
}
