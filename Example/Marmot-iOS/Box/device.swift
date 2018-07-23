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
      
      device_helper.availableMemory()
      let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
      let dict = [
        "disk": ["free": formatter(size: attrs[FileAttributeKey.systemFreeSize] as! Int),
                 "total": formatter(size: attrs[FileAttributeKey.systemSize] as! Int)],
        "memory": ["free": formatter(size: freeMemory()),
                   "total": formatter(size: Int(ProcessInfo.processInfo.physicalMemory)),
                   "used": formatter(size: usedMemory())]
      ]
      return dict
      
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
    return ["value": wlanAddress ?? ""]
  }
  
  @objc func router_networkType() {
    
  }
  
}

extension Router_device {
  
  /// 获取局域网IP
  func wlanAddress() -> String? {
    var address : String?
    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
      let interface = ifptr.pointee
      let addrFamily = interface.ifa_addr.pointee.sa_family
      if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
        let name = String(cString: interface.ifa_name)
        if  name == "en0" {
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
    return address
  }
  
  // 获取当前设备可用内存(单位：B）
  func freeMemory() -> Int {
    var vmStats = vm_statistics_data_t()
    var infoCount = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
    let kernReturn: kern_return_t = withUnsafeMutableBytes(of: &vmStats) {
      let boundBuffer = $0.bindMemory(to: Int32.self)
      return host_statistics(mach_host_self(), HOST_VM_INFO, boundBuffer.baseAddress, &infoCount)
    }
    if (kernReturn != KERN_SUCCESS) { return -1 }
    return Int(vm_page_size) * Int(vmStats.free_count)
  }
  
  // 获取当前任务所占用的内存（单位：B）
  func usedMemory() -> Int {
    var taskInfo = task_basic_info_data_t()
    var infoCount = mach_msg_type_number_t(MemoryLayout<task_basic_info_data_t>.stride / MemoryLayout<natural_t>.stride)
    let kernReturn: kern_return_t = withUnsafeMutableBytes(of: &taskInfo) {
      let boundBuffer = $0.bindMemory(to: Int32.self)
      return task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), boundBuffer.baseAddress, &infoCount)
    }
    if (kernReturn != KERN_SUCCESS) { return -1 }
    return Int(taskInfo.resident_size)
  }
  
}
