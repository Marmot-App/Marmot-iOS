//
//  wx.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Khala
import BLFoundation
import WebKit
import Marmot

struct WXAPPInfo {
  static let version = "1.0.0"
}

@objc(MT_wx) @objcMembers
class MT_wx: NSObject {
  
  
  /// 获取系统信息
  func getSystemInfo(_ info: KhalaInfo) -> KhalaInfo {
    guard let webview = info["webview"] as? WKWebView else { return ["error": "webview 未获取到"] }
    return [
      "brand": Device.type.rawValue,
      "model": Device.version.rawValue,
      "pixelRatio": UIScreen.main.scale,
      "screenWidth": UIScreen.main.bounds.width * UIScreen.main.scale,
      "screenHeight": UIScreen.main.bounds.height * UIScreen.main.scale,
      "windowWidth": UIScreen.main.bounds.height * webview.frame.width,
      "windowHeight": UIScreen.main.bounds.height * webview.frame.height,
      "statusBarHeight": UIScreen.main.bounds.height * UIApplication.shared.statusBarFrame.height,
      "language": Locale.current.languageCode ?? "",
      "version": WXAPPInfo.version,
      "system": UIDevice.current.systemName + " - " + UIDevice.current.systemVersion,
      "platform": Device.type.rawValue,
      "fontSizeSetting": "",
// "SDKVersion": Marmot.version,
      "benchmarkLevel": 50
    ]
    
  }
  

}
