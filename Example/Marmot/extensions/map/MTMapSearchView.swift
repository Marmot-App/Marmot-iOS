//
//  MTMapSearchView.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/21.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MapKit

protocol MTMapSearchViewDelegate: NSObjectProtocol {
  func mapSearchView(didSelect coor: CLLocationCoordinate2D)
}


class MTMapSearchView: UIControl {
  
  weak var delegate: MTMapSearchViewDelegate?
  
  let cellID = "MTMapSearchView.cell"
  
  var key: String = "" {
    didSet {
      if key.isEmpty {
        list.removeAll()
      }else{
        requestData()
      }
    }
  }
  
  var list: [MKMapItem] = [] {
    didSet{
      updateUI()
    }
  }
  
  lazy var tableView: UITableView = {
    let item = UITableView(frame: .zero, style: .plain)
    item.rowHeight = 45
    item.isHidden = true
    item.tableFooterView = UIView()
    item.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
    item.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    return item
  }()
  
  func requestData() {
    let req = MKLocalSearch.Request()
    req.naturalLanguageQuery = key
    let ser = MKLocalSearch(request: req)
    ser.start { [weak self] (response, error) in
      guard let base = self else { return }
      guard let list = response?.mapItems else {
        self?.list.removeAll()
        return
      }
      base.list = list
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension MTMapSearchView {
  
  func updateUI() {
    tableView.isHidden = list.isEmpty
    tableView.reloadData()
  }
  
  @objc func closeEvent() {
    UIApplication.shared.keyWindow?.endEditing(true)
    self.isHidden = true
  }
}

extension MTMapSearchView {
  
  private func buildUI() {
    addSubview(tableView)
    buildLayout()
    buildSubviews()
  }
  
  private func buildLayout() {
    tableView.snp.makeConstraints { (make) in
      make.top.bottom.right.left.equalToSuperview()
    }
  }
  
  private func buildSubviews() {
    self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    self.addTarget(self, action: #selector(closeEvent), for: .touchUpInside)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
}

extension MTMapSearchView: UITableViewDataSource,UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
    cell?.textLabel?.text = list[indexPath.item].name
    cell?.detailTextLabel?.text = list[indexPath.item].phoneNumber
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    isHidden = true
    UIApplication.shared.keyWindow?.endEditing(true)
    delegate?.mapSearchView(didSelect: list[indexPath.item].placemark.coordinate)
  }
  
}
