//
//  BLFoundation
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

//import Foundation
//
//public extension Device {
//  
//  /// 获取局域网IP
//  public var wlanAddress: String? {
//    var address : String?
//    var ifaddr : UnsafeMutablePointer<ifaddrs>?
//    guard getifaddrs(&ifaddr) == 0 else { return nil }
//    guard let firstAddr = ifaddr else { return nil }
//    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
//      let interface = ifptr.pointee
//      let addrFamily = interface.ifa_addr.pointee.sa_family
//      if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//        let name = String(cString: interface.ifa_name)
//        if  name == "en0" {
//          var addr = interface.ifa_addr.pointee
//          var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//          getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
//                      &hostname, socklen_t(hostname.count),
//                      nil, socklen_t(0), NI_NUMERICHOST)
//          address = String(cString: hostname)
//        }
//      }
//    }
//    freeifaddrs(ifaddr)
//    return address
//  }
//  
//}
//
//#if canImport(SystemConfiguration)
//
//import SystemConfiguration
//import SystemConfiguration.CaptiveNetwork
//
//public extension Device {
//
//  public struct WIFI {
//    public var ssid: String? = nil
//    public var bssid: String? = nil
//    public var ssidData: Data? = nil
//
//    public init?() {
//      guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else { return nil }
//      interfaceNames.forEach{ (name) in
//        guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:Any] else { return }
//        if let res = info[kCNNetworkInfoKeySSID as String] as? String { ssid = res }
//        if let res = info[kCNNetworkInfoKeyBSSID as String]  as? String { bssid = res }
//        if let res = info[kCNNetworkInfoKeySSIDData as String] as? Data { ssidData = res }
//      }
//    }
//  }
//
//}
//
//
//#endif
