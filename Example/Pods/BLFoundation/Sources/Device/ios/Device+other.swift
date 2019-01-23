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
  
  /// 是否支持 Taptic Engine 功能
  public var isSupportTaptic: Bool {
    guard let version = Device.versionCode.split(separator: ",").first?.filter ({ (item) -> Bool in
      return !("a"..."z").contains(item)
    }), let num = Int(version) else { return false }
    return num > 8
  }
  
  /// 是否越狱
  public var isJailbroken: Bool {
    if Device.type == .simulator { return false }
    let paths = ["/Applications/Cydia.app",
                 "/private/var/lib/apt/",
                 "/private/var/lib/cydia",
                 "/private/var/stash"]
    
    if paths.first(where: { return FileManager.default.fileExists(atPath: $0) }) != nil { return true }
    
    if let bash = fopen("/bin/bash", "r") {
      fclose(bash)
      return true
    }
    
    if let uuid = CFUUIDCreate(nil),
      let string = CFUUIDCreateString(nil, uuid) {
      let path = "/private/" + (string as String)
      do{
        try "test".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        try FileManager.default.removeItem(atPath: path)
        return true
      }catch{
        
      }
    }
    return false
  }
  
}

