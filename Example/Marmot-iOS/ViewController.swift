//
//  ViewController.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/4.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore
import SnapKit
import Marmot

class ViewController: UIViewController {
  
  let webview = MarmotWebView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(webview)
    webview.snp.makeConstraints { (make) in
      make.top.bottom.right.left.equalToSuperview()
    }
    
    let url = URL(string: "http://localhost:8080/#/device")!
    webview.load(URLRequest(url: url))
  }


}

