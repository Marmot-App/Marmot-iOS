//
//  File.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/6.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
import AudioToolbox
import BLFoundation
import Marmot
import Stem

@objc(MT_device) @objcMembers
class MT_device: NSObject {
  
  
  /// 获取系统信息
  func info() -> [String: Any] {
    var result = [String: Any]()
    result["screen"] = [
      "orientation": UIDevice.current.orientation.rawValue,
      "width": UIScreen.main.bounds.width,
      "height": UIScreen.main.bounds.height,
      "scale": UIScreen.main.scale
    ]
    
    result["battery"] = [
      "state": UIDevice.current.batteryState.rawValue,
      "level": UIDevice.current.batteryLevel
    ]
    
    result["version"] = UIApplication.info.version
    result["language"] = Locale.preferredLanguages.first
    result["model"] = Device.version.rawValue
    
    return result
  }
  
  /// 在有 Taptic Engine 的设备上触发一个轻微的振动
  ///
  /// - Parameter _info: value: 0 ~ 2 表示振动等级
  func taptic(_ info: [String: Any]) {
    if let value = info["value"] as? Int {
      UIDevice.current.st.taptic(level: value)
    }
  }
  
  /// 打开/关闭 手电筒
  ///
  /// - Parameter info: value: 0 ~ 1
  func torch(_ info: [String: Any]) -> [String: Any] {
    if let value = info["value"] as? Double {
      UIDevice.current.st.torch(level: value)
    }
    return ["value": UIDevice.current.st.torchLevel]
  }
  
  /// 获取设备的内存/磁盘空间：
  func space() -> [String: Any] {
    var result = [String: Any]()
    
    result["disk"] = ["free": [
      "bytes": 1,
      "string": "1"
      ],"total": [
        "bytes": 1,
        "string": "1"
      ]]
    
    result["memory"] = ["free": [
      "bytes": 1,
      "string": "1"
      ],"total": [
        "bytes": 1,
        "string": "1"
      ]]
    
    return result
  }
  
}
