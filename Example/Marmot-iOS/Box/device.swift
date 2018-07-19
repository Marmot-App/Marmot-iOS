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
  
  func supportTaptic() -> Bool {
    var systemInfo = utsname()
    uname(&systemInfo)
    let versionCode: String = String(validatingUTF8: NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)!.utf8String!)!
    
    guard let version = versionCode
      .replacingOccurrences(of: "iPhone", with: "")
      .components(separatedBy: ",").first,
      let num = NumberFormatter().number(from: version) else {
        return false
    }
    
    return num.intValue > 8
  }
  
  
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
    
    let level: Int = format(params["value"])
    if #available(iOS 10.0, *), supportTaptic(), let style = UIImpactFeedbackStyle(rawValue: level) {
      let tapticEngine = UIImpactFeedbackGenerator(style: style)
      tapticEngine.prepare()
      tapticEngine.impactOccurred()
    }else{
      switch level {
      case 3:
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
      case 2:
        // 连续三次短震
        AudioServicesPlaySystemSound(1521)
      case 1:
        // 普通短震，3D Touch 中 Pop 震动反馈
        AudioServicesPlaySystemSound(1520)
      default:
        // 普通短震，3D Touch 中 Peek 震动反馈
        AudioServicesPlaySystemSound(1519)
      }
    }
    
  }
  
  
  @objc func router_wlanAddress() -> [String: Any]? {
    var address : String?
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }
    
    // For each interface ...
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
      let interface = ifptr.pointee
      
      // Check for IPv4 or IPv6 interface:
      let addrFamily = interface.ifa_addr.pointee.sa_family
      if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
        
        // Check interface name:
        let name = String(cString: interface.ifa_name)
        if  name == "en0" {
          // Convert interface address to a human readable string:
          var addr = interface.ifa_addr.pointee
          var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
          getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                      &hostname, socklen_t(hostname.count),
                      nil, socklen_t(0), NI_NUMERICHOST)
          address = String(cString: hostname)
        }
      }
    }
    freeifaddrs(ifaddr)
    return ["value": address ?? ""]
  }
  
  @objc func router_networkType() {
    
  }
  
}
