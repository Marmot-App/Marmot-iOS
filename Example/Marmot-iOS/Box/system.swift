//
//  System.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/12.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import AnyFormatProtocol
import MediaPlayer

@objc(Router_system)
class Router_system: NSObject,AnyFormatProtocol {
  
  /// 设置屏幕亮度
  ///
  /// - Parameter params: value(number) 0.0 ~ 1.0
  /// - Returns: 亮度信息 { value: 0.1 ~ 1.0 }
  @objc func router_brightness(params: [String: Any]) -> [String: Any] {
    if params.keys.contains("value") {
      let value: Double = format(params["value"])
      UIScreen.main.brightness = CGFloat(value)
    }
    return ["value": Double(UIScreen.main.brightness)]
  }
  
  /// 设置系统音量
  ///
  /// - Parameter params: value(number) 0.0 ~ 1.0
  /// - Returns: 亮度信息 { value: 0.1 ~ 1.0 }
  @objc func router_volume(params: [String: Any])  -> [String: Any] {
    return ["value": "还没找到合理设置方式"]
  }
  
  /// 拨打电话
  ///
  /// - Parameter params: 号码: value(string)
  /// - Returns: 错误信息
  @objc func router_call(params: [String: Any]) -> [String: Any]? {
    let value: String = format(params["value"])
    if value.isEmpty { return ["error": "号码不能为空"] }
    guard let url = URL(string: "tel:" + value) else { return nil }
    UIApplication.shared.openURL(url)
    return nil
  }
  
  /// 发送短信
  ///
  /// - Parameter params: 号码: value(string)
  /// - Returns: 错误信息
  @objc func router_sms(params: [String: Any]) -> [String: Any]? {
    let value: String = format(params["value"])
    if value.isEmpty { return ["error": "号码不能为空"] }
    guard let url = URL(string: "sms:" + value) else { return nil }
    UIApplication.shared.openURL(url)
    return nil
  }
  
  /// 发送邮件
  ///
  /// - Parameter params: 目标邮箱: value(string)
  /// - Returns: 错误信息
  @objc func router_mailto(params: [String: Any]) -> [String: Any]? {
    let value: String = format(params["value"])
    if value.isEmpty { return ["error": "邮件地址不能为空"] }
    guard let url = URL(string: "mailto:" + value) else { return nil }
    UIApplication.shared.openURL(url)
    return nil
  }
  
  /// FaceTime
  ///
  /// - Parameter params: 目标邮箱: value(string)
  /// - Returns: 错误信息
  @objc func router_facetime(params: [String: Any]) -> [String: Any]? {
    let value: String = format(params["value"])
    if value.isEmpty { return ["error": "邮件地址不能为空"] }
    guard let url = URL(string: "facetime:" + value) else { return nil }
    UIApplication.shared.openURL(url)
    return nil
  }
  
  @objc func router_makeIcon(params: [String: Any]) -> [String: Any]? {
    
    return nil
  }
  
}
