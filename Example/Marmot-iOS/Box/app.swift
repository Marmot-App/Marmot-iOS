//
//  App.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/13.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@objc(Router_app)
class Router_app: NSObject {
  
  /// 返回 app 本身的信息
  ///
  /// - Returns: info.plist 部分参数
  @objc func router_info() -> [String: Any]? {
    var dict = [String: Any]()
    
    if let value = Bundle.main.bundleIdentifier {
      dict["bundleID"] = value
    }
    
    if let value = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
      dict["version"] = value
    }
    
    if let value = Bundle.main.infoDictionary?["CFBundleVersion"] {
      dict["build"] = value
    }
    
    return dict
  }
  
  /// 设置成 true 时屏幕不会自动休眠：
  ///
  /// - Parameter params: value(bool)
  /// - Returns: 是否自动休眠
  @objc func router_idleTimerDisabled(params: [String: Any]) -> [String: Any]? {
    if let value = params["value"] as? Bool {
      UIApplication.shared.isIdleTimerDisabled = value
    }
    return ["value": UIApplication.shared.isIdleTimerDisabled]
  }
  
  /// 打开一个 URL
  ///
  /// - Parameter params: value(string)
  /// - Returns: 错误信息
  @objc func router_openURL(params: [String: Any]) -> [String: Any]? {
    if let str = params["value"] as? String, let url = URL.init(string: str) {
      UIApplication.shared.openURL(url)
      return nil
    }else{
      return ["error": "类型错误"]
    }
  }
  
}
