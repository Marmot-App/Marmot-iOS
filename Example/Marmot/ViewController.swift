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
import Khala

class ViewController: UIViewController {

  lazy var webview: MarmotWebView = {
    let item = MarmotWebView()
    if let path = Bundle.main.path(forResource: "MT", ofType: "js") {
      item.injectJSFlie(path: path)
    }
    return item
  }()
  
  lazy var btn = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Khala.rewrite.filters.append(RewriteFilter({ (item) -> KhalaURLValue in
      if item.url.scheme == "mt" {
        var urlComponents = URLComponents(url: item.url, resolvingAgainstBaseURL: true)
        urlComponents?.host = "MT_" + (item.url.host ?? "")
        item.url = urlComponents?.url ?? item.url
        return item
      }else{
        return item
      }
    }))
    
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
    
    btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
    btn.backgroundColor = UIColor.yellow
    btn.layer.cornerRadius = 5
    btn.layer.masksToBounds = true
    
    btn.setTitle("reload", for: UIControl.State.normal)
    btn.addTarget(self, action: #selector(tapEvent(_:)), for: UIControl.Event.touchUpInside)
  }
  
  @IBAction func tapEvent(_ sender: UIButton) {
    // let url = URL(string: "http://127.0.0.1:8081/")!
    let url = URL(string: "http://192.168.43.85:8081/")!
    webview.load(URLRequest(url: url))
  }
  
}

