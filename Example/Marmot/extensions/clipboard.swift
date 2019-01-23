//
//  clipboard.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Khala

@objc(MT_clipboard) @objcMembers
class MT_clipboard: NSObject {

  func setText(_ info: KhalaInfo) {
    UIPasteboard.general.string = info["value"] as? String ?? ""
  }
  
  
  func text() -> KhalaInfo {
    return ["value": UIPasteboard.general.string ?? ""]
  }
  
  
}
