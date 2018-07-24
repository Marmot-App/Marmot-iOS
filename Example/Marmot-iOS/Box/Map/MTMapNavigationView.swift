//
//  MTMapNavigationView.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/24.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit


protocol MTMapNavigationViewDelegate: NSObjectProtocol {
  func mapNavigationView(view: MTMapNavigationView, didBeginEdit: Bool)
  func mapNavigationView(view: MTMapNavigationView, closeEvent: Bool)
  func mapNavigationView(view: MTMapNavigationView, cancelEvent: Bool)
  func mapNavigationView(view: MTMapNavigationView, changed text: String)
}

class MTMapNavigationView: UIView {
  
  weak var delegate: MTMapNavigationViewDelegate?
  
  lazy var closeBtn: UIButton = {
    let item = UIButton()
    item.setImage(UIImage(named: "close"), for: .normal)
    return item
  }()
  
  lazy var cancelBtn: UIButton = {
    let item = UIButton()
    item.setTitle("取消", for: .normal)
    return item
  }()
  
  lazy var textField: UITextField = {
    let item = UITextField()
    item.clearButtonMode = .whileEditing
    item.borderStyle = .roundedRect
    item.tintColor = UIColor.black
    item.backgroundColor = UIColor.white
    item.placeholder = "搜索地点或地址"
    item.leftViewMode = .always
    item.returnKeyType = .done
    item.leftView = UIImageView(image: UIImage(named: "search"))
    item.leftView?.frame.size.width += 10
    item.leftView?.contentMode = .scaleAspectFit
    return item
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension MTMapNavigationView {
  
  private func buildUI() {
    backgroundColor = .blue
    addSubview(textField)
    addSubview(closeBtn)
    addSubview(cancelBtn)
    buildLayout()
    buildSubviews()
  }
  
  private func buildLayout() {
    closeBtn.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.bottom.equalToSuperview().offset(-5)
      make.width.height.equalTo(44)
    }
    
    cancelBtn.snp.makeConstraints { (make) in
      make.left.equalTo(textField.snp.right).offset(10)
      make.centerY.equalTo(closeBtn.snp.centerY)
      make.height.equalTo(44)
      make.width.equalTo(60)
    }
    
    textField.snp.makeConstraints { (make) in
      make.centerY.equalTo(closeBtn.snp.centerY)
      make.left.equalTo(closeBtn.snp.right).offset(10)
      make.right.equalToSuperview().offset(-15)
      make.height.equalTo(35)
    }
  }
  
  private func buildSubviews() {
    closeBtn.addTarget(self, action: #selector(closeEvent), for: .touchUpInside)
    cancelBtn.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
    textField.delegate = self
    textField.addTarget(self, action: #selector(textField(changed:)), for: .editingChanged)
  }
  
}

extension MTMapNavigationView {
  
  @objc func cancelEvent() {
    textField.text = ""
    textField.endEditing(true)
    delegate?.mapNavigationView(view: self, cancelEvent: true)
  }
  
  @objc func closeEvent() {
    delegate?.mapNavigationView(view: self, closeEvent: true)
  }
  
}


extension MTMapNavigationView: UITextFieldDelegate {
  
  @objc func textField(changed textField: UITextField) {
    delegate?.mapNavigationView(view: self, changed: textField.text ?? "")
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    delegate?.mapNavigationView(view: self, didBeginEdit: true)
    UIView.animate(withDuration: 0.5) {
      textField.snp.updateConstraints({ (make) in
        make.right.equalToSuperview().offset(-80)
      })
      self.layoutIfNeeded()
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.5) {
      textField.snp.updateConstraints({ (make) in
        make.right.equalToSuperview().offset(-15)
      })
      self.layoutIfNeeded()
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
  }
  
  
}
