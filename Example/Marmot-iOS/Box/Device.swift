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
import AnyFormatProtocol

@objc(Router_device)
class Router_device: NSObject,AnyFormatProtocol {
  
  /// 返回设备的基本信息
  ///
  /// - Returns: 设备的基本信息
  @objc func router_info() -> [String:Any] {
    let device = UIDevice.current
    let screen = UIScreen.main
    
    var dict = ["name": device.name,
                "model": device.model,
                "systemVersion": device.systemVersion] as [String : Any]
    
    dict["screen"] = ["width": screen.bounds.size.width,
                      "height": screen.bounds.size.height,
                      "scale": screen.scale,
                      "orientation": device.orientation.rawValue]
    
    dict["language"] = NSLocale.preferredLanguages.first ?? ""
    
    dict["battery"] = [
      "level": device.batteryLevel,
      "state": device.batteryState.rawValue
    ]
    
    return dict
  }
  
  /// 获取当前 Wi-Fi 的 SSID 信息
  ///
  /// - Returns: SSID 信息
  @objc func router_ssid() -> [[String: Any]]? {
    guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else { return nil }
    return interfaceNames.flatMap { (name) -> [String: Any]? in
      guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:Any] else { return nil }
      var dict = [String: Any]()
      if let res = info[kCNNetworkInfoKeySSID as String] {
        dict["SSID"] = res
      }
      if let res = info[kCNNetworkInfoKeyBSSID as String] {
        dict["BSSID"] = res
      }
      if let res = info[kCNNetworkInfoKeySSIDData as String] as? Data {
        dict["SSIDDATA"] = String(data: res, encoding: .utf8)
      }
      return dict
    }
  }
  
  /// 获取设备的内存/磁盘空间：
  ///
  /// - Returns: 设备的内存/磁盘空间
  @objc func router_space() -> [String: Any]? {
    func formatter(size: Int) -> [String: Any] {
      if size > 1000 * 1000 * 1000 {
        return ["bytes": size,
                "string": String(format: "%.2f GB", Double(size) / 1000000000)]
      }
      
      if size > 1000 * 1000 {
        return ["bytes": size,
                "string": String(format: "%.2f MB", Double(size) / 1000000)]
      }
      
      if size > 1000 {
        return ["bytes": size,
                "string": String(format: "%.2f KB", Double(size) / 1000)]
      }
      
      return ["bytes": size,
              "string": String(format: "%.2f B", Double(size))]
    }
    do {
      let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
      return[
        "disk": ["free": formatter(size: attrs[FileAttributeKey.systemFreeSize] as! Int),
                 "total": formatter(size: attrs[FileAttributeKey.systemSize] as! Int)]
      ]
      
    }catch {
      return ["error": error.localizedDescription]
    }
  }
  
  
  /// 在有 Taptic Engine 的设备上触发一个轻微的振动
  ///
  /// - Parameter params: level  (number)  0 ~ 2 表示振动等级
  @objc func router_taptic(params: [String: Any]) {
    
    if false {
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    if false {
      // 普通短震，3D Touch 中 Peek 震动反馈
      AudioServicesPlaySystemSound(1519)
      // 普通短震，3D Touch 中 Pop 震动反馈
      AudioServicesPlaySystemSound(1520)
      // 连续三次短震
      AudioServicesPlaySystemSound(1521)
    }
    
    if #available(iOS 10.0, *), let style = UIImpactFeedbackStyle(rawValue: format(params["level"])) {
      let tapticEngine = UIImpactFeedbackGenerator(style: style)
      tapticEngine.prepare()
      tapticEngine.impactOccurred()
    }
    
  }
  
  
  @objc func router_wlanAddress() {
    
  }
  
  @objc func router_networkType() {
    
  }
  
}
