//
//  clipboard.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@objc(Router_clipboard)
class Router_clipboard: NSObject {
  
  @objc func router_text(params: [String: Any]) -> [String: Any]? {
    if let value = params["value"] as? String {
      UIPasteboard.general.string = value
    }
    return ["value": UIPasteboard.general.string ?? ""]
  }
  
  @objc func router_image(params: [String: Any]) -> [String: Any]? {
//    if let value = params["value"] as? String {
//      UIPasteboard.general.image = value
//    }
//    return ["value": UIPasteboard.general.image]
    return nil
  }
  
}
