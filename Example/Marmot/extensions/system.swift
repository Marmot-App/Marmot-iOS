//
//  App.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/7.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Khala

@objc(MT_system) @objcMembers
class MT_system: NSObject {
  
  /// 设置屏幕亮度
  ///
  /// - Parameter info: value(number) 0.0 ~ 1.0
  /// - Returns: 亮度信息 { value: 0.1 ~ 1.0 }
  func brightness(_ info: [String: Any]) -> [String: Any] {
    if let value = info["value"] as? CGFloat {
      UIScreen.main.brightness = value
    }
    return ["value": UIScreen.main.brightness]
  }
  
  /// 设置系统音量
  ///
  /// - Parameter params: value(number) 0.0 ~ 1.0
  /// - Returns: 亮度信息 { value: 0.1 ~ 1.0 }
  func volume(_ info: [String: Any])  -> [String: Any] {
    return ["value": "还没找到合理设置方式"]
  }
  
  /// 拨打电话
  ///
  /// - Parameter params: 号码: value(string)
  /// - Returns: 错误信息
  func call(_ info: [String: Any]) -> [String: Any] {
    if let value = info["value"] as? String {
      UIApplication.shared.st.open(url: "tel:" + value)
    }else{
      return ["error": "号码不能为空"]
    }
    return [:]
  }
  
  /// 发送短信
  ///
  /// - Parameter params: 号码: value(string)
  /// - Returns: 错误信息
  func sms(_ info: [String: Any]) -> [String: Any] {
    if let value = info["value"] as? String {
      UIApplication.shared.st.open(url: "sms:" + value)
    }else{
      return ["error": "号码:不能为空"]
    }
    return [:]
  }
  
  /// 发送邮件
  ///
  /// - Parameter params: 目标邮箱: value(string)
  /// - Returns: 错误信息
  func mailto(_ info: [String: Any]) -> [String: Any] {
    if let value = info["value"] as? String {
      UIApplication.shared.st.open(url: "mailto:" + value)
    }else{
      return ["error": "邮件地址不能为空"]
    }
    return [:]
  }
  
  /// FaceTime
  ///
  /// - Parameter params: 目标邮箱: value(string)
  /// - Returns: 错误信息
  func facetime(_ info: [String: Any]) -> [String: Any]? {
    if let value = info["value"] as? String {
      UIApplication.shared.st.open(url: "facetime:" + value)
    }else{
      return ["error": "邮件地址不能为空"]
    }
    return [:]
  }
  
  func makeIcon(params: [String: Any]) -> [String: Any]? {
    return nil
  }
  
}
