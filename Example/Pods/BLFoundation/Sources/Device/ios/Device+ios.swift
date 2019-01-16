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

public extension Device {
  /// 判断设备类型
  ///
  /// - Parameter type: 设备类型
  /// - Returns: true or false
  public static func `is`(_ type: Type) -> Bool {
    return self.type == type
  }
  
  /// 判断设备版本
  ///
  /// - Parameter version: 设备版本
  /// - Returns: true or false
  public static func `is`(_ version: Version) -> Bool {
    return self.version == version
  }
  
  
  /// apple 机型内部版本标识
  public static var versionCode: String {
    getInfo()
    return getVersionCode()
  }
  
  /// 设备类型
  public static var type: Type {
    getInfo()
    return _type
  }
  
  /// 设备版本类型
  public static var version: Version {
    getInfo()
    return _version
  }
  
  private static var _type = Type.unknown
  private static var _version = Version.unknown
  private static var _versionCode = ""
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
    if _type != .unknown,_version != .unknown, !_versionCode.isEmpty { return }
    _versionCode = getVersionCode()
    switch _versionCode {
      /*** iPhone ***/
    case "iPhone3,1", "iPhone3,2", "iPhone3,3": _type = .iPhone; _version = .iPhone4
    case "iPhone4,1", "iPhone4,2", "iPhone4,3": _type = .iPhone; _version = .iPhone4S
    case "iPhone5,1", "iPhone5,2":              _type = .iPhone; _version = .iPhone5
    case "iPhone5,3", "iPhone5,4":              _type = .iPhone; _version = .iPhone5C
    case "iPhone6,1", "iPhone6,2":              _type = .iPhone; _version = .iPhone5S
    case "iPhone7,2":                           _type = .iPhone; _version = .iPhone6
    case "iPhone7,1":                           _type = .iPhone; _version = .iPhone6Plus
    case "iPhone8,1":                           _type = .iPhone; _version = .iPhone6S
    case "iPhone8,2":                           _type = .iPhone; _version = .iPhone6SPlus
    case "iPhone8,4":                           _type = .iPhone; _version = .iPhoneSE
    case "iPhone9,1", "iPhone9,3":              _type = .iPhone; _version = .iPhone7
    case "iPhone9,2", "iPhone9,4":              _type = .iPhone; _version = .iPhone7Plus
    case "iPhone10,1", "iPhone10,4":            _type = .iPhone; _version = .iPhone8
    case "iPhone10,2", "iPhone10,5":            _type = .iPhone; _version = .iPhone8Plus
    case "iPhone10,3", "iPhone10,6":            _type = .iPhone; _version = .iPhoneX
    case "iPhone11,2":                          _type = .iPhone; _version = .iPhoneXS
    case "iPhone11,4", "iPhone11,6":            _type = .iPhone; _version = .iPhoneXSMax
    case "iPhone11,8":                           _type = .iPhone; _version = .iPhoneXR
      /*** iPad ***/
    case "iPad1,1":                                 _type = .iPad; _version = .iPad1
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":_type = .iPad; _version = .iPad2
    case "iPad3,1", "iPad3,2", "iPad3,3":           _type = .iPad; _version = .iPad3
    case "iPad3,4", "iPad3,5", "iPad3,6":           _type = .iPad; _version = .iPad4
    case "iPad6,11", "iPad6,12":                    _type = .iPad; _version = .iPad5
    case "iPad4,1", "iPad4,2", "iPad4,3":           _type = .iPad; _version = .iPadAir
    case "iPad5,3", "iPad5,4":                      _type = .iPad; _version = .iPadAir2
    case "iPad2,5", "iPad2,6", "iPad2,7":           _type = .iPad; _version = .iPadMini
    case "iPad4,4", "iPad4,5", "iPad4,6":           _type = .iPad; _version = .iPadMini2
    case "iPad4,7", "iPad4,8", "iPad4,9":           _type = .iPad; _version = .iPadMini3
    case "iPad5,1", "iPad5,2":                      _type = .iPad; _version = .iPadMini4
    case "iPad6,7", "iPad6,8", "iPad7,1", "iPad7,2":_type = .iPad; _version = .iPadPro12_9Inch
    case "iPad7,3", "iPad7,4":                      _type = .iPad; _version = .iPadPro10_5Inch
    case "iPad6,3", "iPad6,4":                      _type = .iPad; _version = .iPadPro9_7Inch
      /*** iPod ***/
    case "iPod1,1":                                 _type = .iPod; _version = .iPodTouch1Gen
    case "iPod2,1":                                 _type = .iPod; _version = .iPodTouch2Gen
    case "iPod3,1":                                 _type = .iPod; _version = .iPodTouch3Gen
    case "iPod4,1":                                 _type = .iPod; _version = .iPodTouch4Gen
    case "iPod5,1":                                 _type = .iPod; _version = .iPodTouch5Gen
    case "iPod7,1":                                 _type = .iPod; _version = .iPodTouch6Gen
      /*** Simulator ***/
    case "i386", "x86_64":                          _type = .simulator; _version = .simulator
    default:                                        _type = .unknown;   _version = .unknown
    }
  }
  
}

// MARK: - enum
extension Device {
  
  public enum `Type`: String,CaseIterable {
    case iPhone
    case iPad
    case iPod
    case simulator
    case unknown
  }
  
  public enum Version: String,CaseIterable {
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
    case iPhoneXS
    case iPhoneXSMax
    case iPhoneXR
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
