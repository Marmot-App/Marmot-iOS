//
//  clipboard.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

@objc(MT_clipboard) @objcMembers
class MT_clipboard: NSObject {

  func setText(_ info: [String: Any]) {
    UIPasteboard.general.string = info["value"] as? String ?? ""
  }
  
  
  func text() -> [String: Any] {
    return ["value": UIPasteboard.general.string ?? ""]
  }
  
  
}
