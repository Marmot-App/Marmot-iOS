//
//  System.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/12.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import AnyFormatProtocol

@objc(Router_system)
class Router_system: NSObject,AnyFormatProtocol {

  /// 设置屏幕亮度
  ///
  /// - Parameter params: value(number) 0.0 ~ 1.0
  @objc func router_brightness(params: [String: Any]) -> [String: Any] {
    if params.keys.contains("value") {
    let value: Double = format(params["value"])
    UIScreen.main.brightness = CGFloat(value)
    }
    return ["value": Double(UIScreen.main.brightness)]
  }
  
  @objc func router_volume(params: [String: Any]) {

  }
  
  @objc func router_call(params: [String: Any]) {
    let value: String = format(params["value"])
    if value.isEmpty { return }
    guard let url = URL(string: "tel:" + value) else { return }
    UIApplication.shared.openURL(url)
  }
  
}
