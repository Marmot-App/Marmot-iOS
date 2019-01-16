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
  func info(_ info: [String: Any]) -> [String: Any] {
  
    var result = [
      "brand": Device.type.rawValue,
      "model": Device.version.rawValue,
      "screenWidth": UIScreen.main.bounds.width * UIScreen.main.scale,
      "screenHeight": UIScreen.main.bounds.height * UIScreen.main.scale,
      "statusBarHeight": UIApplication.shared.statusBarFrame.height,
      "pixelRatio": UIScreen.main.bounds.width / UIScreen.main.bounds.height
      ] as [String : Any]
    
    
    if let webview = info["webview"] as? MarmotWebView {
      result["windowWidth"] = webview.frame.width * UIScreen.main.scale
      result["windowHeight"] = webview.frame.height * UIScreen.main.scale
      result["language"] = "zh"
      result["version"] = UIApplication.info.version
      result["platform"] = Device.type.rawValue
      result["system"] = UIDevice.current.systemName + "-" + UIDevice.current.systemVersion
      // result["SDKVersion"] = UIApplication.info.version
      result["benchmarkLevel"] = "40"
    }

    return result
  }
  
}
