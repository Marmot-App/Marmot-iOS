//
//  App.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/7.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Khala
import MessageUI
import MediaPlayer
import BLFoundation

@objc(MT_system) @objcMembers
class MT_system: NSObject {
  
  /// 设置屏幕亮度
  ///
  /// - Parameter info: value(number) 0.0 ~ 1.0
  /// - Returns: 亮度信息 { value: 0.1 ~ 1.0 }
  func brightness(_ info: KhalaInfo) -> KhalaInfo {
    if let value = info["value"] as? CGFloat {
      UIScreen.main.brightness = value
      return ["value": value]
    }
    return ["value": Double(UIScreen.main.brightness).round(places: 2)]
  }
  
  lazy var volumView = MPVolumeView(frame: CGRect(x: 0, y: 100, width: 100, height: 40))
  
  /// 设置系统音量
  ///
  /// - Parameter params: value(number) 0.0 ~ 1.0
  /// - Returns: 音量信息 { value: 0.1 ~ 1.0 }
  func volume(_ info: KhalaInfo) -> KhalaInfo {
    let slider = volumView.subviews.first { (item) -> Bool in
      return item.description.contains("MPVolumeSlider")
      } as? UISlider
    
    volumView.removeFromSuperview()
    UIViewController.current?.view.addSubview(volumView)
    
    if let value = info["value"] as? Double {
      slider?.setValue(Float(value), animated: false)
    }
    volumView.removeFromSuperview()
    return ["value": Double(slider?.value ?? 0)]
  }
  
  /// 拨打电话
  ///
  /// - Parameter params: 号码: value(string)
  /// - Returns: 错误信息
  func call(_ info: KhalaInfo) -> KhalaInfo {
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
  func sms(_ info: KhalaInfo) -> KhalaInfo {
    if let value = info["value"] as? String {
      UIApplication.shared.st.open(url: "sms:" + value)
    } else if let value = info["value"] as? [String] {
      if MFMessageComposeViewController.canSendText() {
        let vc = MFMessageComposeViewController()
        vc.recipients = value
        vc.body = info["body"] as? String
        vc.messageComposeDelegate = self
        UIViewController.current?.st.present(vc: vc)
      }
    } else{
      return ["error": "号码:不能为空"]
    }
    return [:]
  }
  
  /// 发送邮件
  ///
  /// - Parameter params: 目标邮箱: value(string)
  /// - Returns: 错误信息
  func mailto(_ info: KhalaInfo) -> KhalaInfo {
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
  func facetime(_ info: KhalaInfo) -> KhalaInfo? {
    if let value = info["value"] as? String {
      UIApplication.shared.st.open(url: "facetime:" + value)
    }else{
      return ["error": "邮件地址不能为空"]
    }
    return [:]
  }
  
  func makeIcon(params: KhalaInfo) -> KhalaInfo? {
    return nil
  }
  
}

extension MT_system: MFMessageComposeViewControllerDelegate {
  
  func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    controller.dismiss(animated: true, completion: nil)
    switch result {
    case .sent:
      break
    case .cancelled:
      break
    case .failed:
      break
    }
  }
  
}
