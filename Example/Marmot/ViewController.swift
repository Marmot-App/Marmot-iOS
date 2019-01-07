//
//  ViewController.swift
//  Marmot
//
//  Created by linhay on 01/05/2019.
//  Copyright (c) 2019 linhay. All rights reserved.
//

import UIKit
import WebKit
import Marmot
import SnapKit
class ViewController: UIViewController {
  
  lazy var webview: MarmotWebView = {
    let item = MarmotWebView()
    return item
  }()
  
  lazy var btn = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(webview)
    self.view.addSubview(btn)
    
    btn.snp.makeConstraints { (make) in
      make.top.equalTo(self.topLayoutGuide.snp.bottom)
      make.left.right.equalToSuperview()
      make.height.equalTo(45)
    }
    
    webview.snp.makeConstraints({ (make) in
      make.top.equalTo(btn.snp.bottom)
      make.left.right.equalToSuperview()
      make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
    })
    
    btn.setTitle("reload", for: UIControl.State.normal)
    btn.addTarget(self, action: #selector(tapEvent(_:)), for: UIControl.Event.touchUpInside)
    
  }
  @IBAction func tapEvent(_ sender: UIButton) {
    let url = URL(string: "http://127.0.0.1:8081/")!
    webview.load(URLRequest(url: url))
  }
  
  
}

