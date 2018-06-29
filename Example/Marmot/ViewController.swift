//
//  ViewController.swift
//  Marmot
//
//  Created by is.linhay@outlook.com on 06/28/2018.
//  Copyright (c) 2018 is.linhay@outlook.com. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {
  
  let webview = WKWebView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(webview)
    let url = URL(string: "https://m.baidu.com")!
    webview.load(URLRequest(url: url))
  }

  override func viewDidAppear() {
    super.viewDidAppear()
    webview.frame = view.bounds

  }

}

