//
//  message.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Khala
import MessageUI
import Stem


@objc(MT_message) @objcMembers
class MT_message: NSObject {

  /// 发送短信
  ///
  /// - Parameter params: 号码: value(string)
  /// - Returns: 错误信息
  func sms(_ info: KhalaInfo, closure: KhalaClosure) {
      if MFMessageComposeViewController.canSendText() {
        let vc = MFMessageComposeViewController()
        vc.recipients = info["recipients"] as? [String]
        vc.body = info["body"] as? String
        vc.subject = info["subject"] as? String
        // todo
        // attachments = info["attachments"] as? [Any]
        vc.messageComposeDelegate = self
        UIViewController.current?.st.present(vc: vc)
      }else {
        closure(["error": "无法调起短信界面"])
    }
  }
  
}


extension MT_message: MFMessageComposeViewControllerDelegate {
  
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
