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

import Foundation

public class Device {
  /// 判断设备类型
  ///
  /// - Parameter type: 设备类型
  /// - Returns: true or false
  public static func `is`(_ type: Type) -> Bool {
    getInfo()
    return self.type == type
  }
  
  /// 判断设备版本
  ///
  /// - Parameter version: 设备版本
  /// - Returns: true or false
  public static func `is`(_ version: Version) -> Bool {
    getInfo()
    return self.version == version
  }
  
  static var type = Type.unknown
  static var version = Version.unknown
}


// MARK: - private
extension Device {
  
  static private func getVersionCode() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let versionCode: String = String(validatingUTF8: NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)!.utf8String!)!
    return versionCode
  }
  
  static private func getInfo() {
    if type != .unknown,version != .unknown { return }
    let code = getVersionCode()
    switch code {
      /*** iPhone ***/
    case "iPhone3,1", "iPhone3,2", "iPhone3,3": type = .iPhone; version = .iPhone4
    case "iPhone4,1", "iPhone4,2", "iPhone4,3": type = .iPhone; version = .iPhone4S
    case "iPhone5,1", "iPhone5,2":              type = .iPhone; version = .iPhone5
    case "iPhone5,3", "iPhone5,4":              type = .iPhone; version = .iPhone5C
    case "iPhone6,1", "iPhone6,2":              type = .iPhone; version = .iPhone5S
    case "iPhone7,2":                           type = .iPhone; version = .iPhone6
    case "iPhone7,1":                           type = .iPhone; version = .iPhone6Plus
    case "iPhone8,1":                           type = .iPhone; version = .iPhone6S
    case "iPhone8,2":                           type = .iPhone; version = .iPhone6SPlus
    case "iPhone8,4":                           type = .iPhone; version = .iPhoneSE
    case "iPhone9,1", "iPhone9,3":              type = .iPhone; version = .iPhone7
    case "iPhone9,2", "iPhone9,4":              type = .iPhone; version = .iPhone7Plus
    case "iPhone10,1", "iPhone10,4":            type = .iPhone; version = .iPhone8
    case "iPhone10,2", "iPhone10,5":            type = .iPhone; version = .iPhone8Plus
    case "iPhone10,3", "iPhone10,6":            type = .iPhone; version = .iPhoneX
      /*** iPad ***/
    case "iPad1,1":                                  type = .iPad; version = .iPad1
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": type = .iPad; version = .iPad2
    case "iPad3,1", "iPad3,2", "iPad3,3":            type = .iPad; version = .iPad3
    case "iPad3,4", "iPad3,5", "iPad3,6":            type = .iPad; version = .iPad4
    case "iPad6,11", "iPad6,12":                     type = .iPad; version = .iPad5
    case "iPad4,1", "iPad4,2", "iPad4,3":            type = .iPad; version = .iPadAir
    case "iPad5,3", "iPad5,4":                       type = .iPad; version = .iPadAir2
    case "iPad2,5", "iPad2,6", "iPad2,7":            type = .iPad; version = .iPadMini
    case "iPad4,4", "iPad4,5", "iPad4,6":            type = .iPad; version = .iPadMini2
    case "iPad4,7", "iPad4,8", "iPad4,9":            type = .iPad; version = .iPadMini3
    case "iPad5,1", "iPad5,2":                       type = .iPad; version = .iPadMini4
    case "iPad6,7", "iPad6,8", "iPad7,1", "iPad7,2": type = .iPad; version = .iPadPro12_9Inch
    case "iPad7,3", "iPad7,4":                       type = .iPad; version = .iPadPro10_5Inch
    case "iPad6,3", "iPad6,4":                       type = .iPad; version = .iPadPro9_7Inch
      /*** iPod ***/
    case "iPod1,1":                                  type = .iPod; version = .iPodTouch1Gen
    case "iPod2,1":                                  type = .iPod; version = .iPodTouch2Gen
    case "iPod3,1":                                  type = .iPod; version = .iPodTouch3Gen
    case "iPod4,1":                                  type = .iPod; version = .iPodTouch4Gen
    case "iPod5,1":                                  type = .iPod; version = .iPodTouch5Gen
    case "iPod7,1":                                  type = .iPod; version = .iPodTouch6Gen
      /*** Simulator ***/
    case "i386", "x86_64":                           type = .simulator; version = .simulator
    default:                                         type = .unknown; version = .unknown
    }
  }
  
}

// MARK: - enum
extension Device {
  
  public enum `Type`: String {
    case iPhone
    case iPad
    case iPod
    case simulator
    case unknown
  }
  
  public enum Version: String {
    /*** iPhone ***/
    case iPhone4
    case iPhone4S
    case iPhone5
    case iPhone5C
    case iPhone5S
    case iPhone6
    case iPhone6Plus
    case iPhone6S
    case iPhone6SPlus
    case iPhoneSE
    case iPhone7
    case iPhone7Plus
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    /*** iPad ***/
    case iPad1
    case iPad2
    case iPad3
    case iPad4
    case iPad5
    case iPadAir
    case iPadAir2
    case iPadMini
    case iPadMini2
    case iPadMini3
    case iPadMini4
    case iPadPro9_7Inch
    case iPadPro10_5Inch
    case iPadPro12_9Inch
    /*** iPod ***/
    case iPodTouch1Gen
    case iPodTouch2Gen
    case iPodTouch3Gen
    case iPodTouch4Gen
    case iPodTouch5Gen
    case iPodTouch6Gen
    /*** simulator ***/
    case simulator
    /*** unknown ***/
    case unknown
  }
  
  
}
