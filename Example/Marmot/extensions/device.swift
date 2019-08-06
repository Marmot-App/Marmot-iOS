//
//  File.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/6.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Khala
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
import AudioToolbox
import BLFoundation
import Marmot
import Stem

@objc(MT_device) @objcMembers
class MT_device: NSObject {
  
  
  /// 获取系统信息
  func info() -> KhalaInfo {
    var result = KhalaInfo()
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
    
    result["version"] = UIApplication.shared.st.info
    result["language"] = Locale.preferredLanguages.first
    result["model"] = Device.version.rawValue
    
    return result
  }
  
  /// 在有 Taptic Engine 的设备上触发一个轻微的振动
  ///
  /// - Parameter _info: value: 0 ~ 2 表示振动等级
  func taptic(_ info: KhalaInfo) {
    if let value = info["value"] as? Int {
      UIDevice.current.st.taptic(level: value,isSupportTaptic: false)
    }
  }
  
  /// 打开/关闭 手电筒
  ///
  /// - Parameter info: value: 0 ~ 1
  func torch(_ info: KhalaInfo) -> KhalaInfo {
    if let value = info["value"] as? Double {
      UIDevice.current.st.torch(level: value)
    }
    return ["value": UIDevice.current.st.torchLevel]
  }
  
  /// 获取设备的内存/磁盘空间：
  func space() -> KhalaInfo {
    
    func toInfo(size: Int) -> [String: Any] {
      if size > 1000 * 1000 * 1000 {
        return ["bytes": size, "string": String(format: "%.2f GB", Double(size) / 1000000000)]
      }
      
      if size > 1000 * 1000 {
        return ["bytes": size, "string": String(format: "%.2f MB", Double(size) / 1000000)]
      }
      
      if size > 1000 {
        return ["bytes": size, "string": String(format: "%.2f KB", Double(size) / 1000)]
      }
      
      return ["bytes": size, "string": String(format: "%.2f B", Double(size))]
    }
    
    
    
    var result = KhalaInfo()
    
    result["disk"] = [
      "free": toInfo(size: Device.diskSpace.free),
      "total": toInfo(size: Device.diskSpace.total)
    ]
    
    result["memory"] = [
      "free": toInfo(size: Device.memorySpace.free),
      "used": toInfo(size: Device.memorySpace.used),
      "total": toInfo(size: Int(ProcessInfo.processInfo.physicalMemory))
    ]
    
    return result
  }
  
}
