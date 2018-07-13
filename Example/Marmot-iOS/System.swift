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
  @objc func router_brightness(params: [String: Any]) {
    let value: Double = format(params["value"])
    UIScreen.main.brightness = CGFloat(value)
  }
  
  @objc func router_volume(params: [String: Any]) {

  }
  
  
  
  
}
