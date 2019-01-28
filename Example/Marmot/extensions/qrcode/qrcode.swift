//
//  qrcode.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Khala
import Stem

@objc(MT_qrcode) @objcMembers
class MT_qrcode: NSObject {

  func scan(_ info: KhalaInfo, closure: @escaping KhalaClosure) {
    let vc = QrcodeViewController(closure: closure)
    UIViewController.current?.st.push(vc: vc)
  }
  
  func decode(_ info: KhalaInfo) {
    let data = Data(bytes: [10,1,2])
  }
  
}
