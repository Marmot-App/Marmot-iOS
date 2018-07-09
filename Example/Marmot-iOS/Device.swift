//
//  File.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/6.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@objc(Router_device)
class Router_device: NSObject {
  
  @objc func router_id() -> String {
    return UIDevice.current.name
  }
  
}
