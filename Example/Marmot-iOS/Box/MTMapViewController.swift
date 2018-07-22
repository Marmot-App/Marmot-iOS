//
//  MapViewController.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/20.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MapKit
import SPRoutable
import SnapKit


class MTMapViewController: UIViewController {
  
  lazy var mapView: MKMapView? = { [weak self] in
    let item = MKMapView()
    guard let base = self else { return item }
    item.showsUserLocation = true
    item.delegate = base
    // 设置地图的显示项
    // 建筑物
    item.showsBuildings = true
    // 指南针
    if #available(iOS 9.0, *) {
      item.showsCompass = true
      // 比例尺
      item.showsScale = true
      // 交通状况
      item.showsTraffic = true
    }
    // poi兴趣点
    item.showsPointsOfInterest = true
    
    let tap = UITapGestureRecognizer(target: base, action: #selector(tapEvent))
    item.addGestureRecognizer(tap)
    return item
    }()
  
  lazy var doneBtn: UIButton = { [weak self] in
    let item = UIButton()
    guard let base = self else { return item }
    item.setTitle("确定", for: UIControlState.normal)
    item.addTarget(base, action: #selector(selectPoint), for: .touchUpInside)
    item.backgroundColor = UIColor.blue
    return item
    }()
  
  lazy var searchView: MTMapSearchView = { [weak self] in
    let item = MTMapSearchView()
    guard let base = self else { return item }
    item.frame = view.bounds
    return item
  }()
  
  lazy var navView: UIView = {
    let item = UIView()
    item.backgroundColor = UIColor.red
    return item
  }()
  
  
  lazy var annImageView: UIImageView = { [weak self] in
    guard let base = self else { return UIImageView() }
    let item = UIImageView(image: UIImage.init(named: "定位"))
    return item
    }()

  
  var mapZoomLevel = 0 {
    didSet{
      if mapZoomLevel == oldValue { return }
      applyMapViewMemoryHotFix()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mapView!)
    view.addSubview(doneBtn)
    view.addSubview(navView)
    
    mapView!.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom)
      make.bottom.left.right.equalToSuperview()
    }
    
    navView.snp.makeConstraints { (make) in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(64)
      
    }
    
    doneBtn.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().offset(-10)
      make.right.equalToSuperview().offset(-15)
      make.left.equalToSuperview().offset(15)
      make.height.equalTo(45)
    }
  }
  
  @objc func tapEvent(ges: UITapGestureRecognizer) {
    //    mapView.removeOverlays(mapView.overlays)
    //    let overlays = MKCircle(center: pointAnnotation.coordinate, radius: 100)
    //    mapView.add(overlays)
  }
  
  @objc func selectPoint() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func close() {
    dismiss(animated: true, completion: nil)
  }
  
  // 地图缩放时内存暴涨
  func applyMapViewMemoryHotFix() {
    switch mapView!.mapType {
    case .hybrid:
      mapView?.mapType = .standard
    case .standard:
      mapView?.mapType = .hybrid
    default:
      break
    }
    mapView?.mapType = .standard
  }
  
  deinit {
    // 内存释放
    mapView = nil
  }
  
}

extension MTMapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    if annImageView.superview != nil { return }
    // 设置地图显示区域
    mapView.setRegion(center: userLocation.coordinate, zoomLevel: 19, animated: false)
    mapView.addSubview(annImageView)

    let item = UIView()
    item.backgroundColor = UIColor.red
    mapView.addSubview(item)
    
    item.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.width.height.equalTo(2)
    }
    
    annImageView.snp.makeConstraints { (make) in
      make.width.height.equalTo(30)
      make.centerX.equalToSuperview()
      make.bottom.equalTo(mapView.snp.centerY)
    }
    
  }
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    mapZoomLevel = mapView.currentZoomLevel
    //    let anima = CABasicAnimation(keyPath: "position")
//    anima.fromValue = 1
//    anima.toValue = 0
//    anima.duration = 1
//    annImageView.layer.add(anima, forKey: "positionAnimation")
  }
  
  func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }
    
    // 如果此方法返回nil, 就会使用系统自带的大头针视图
    // 模拟下，返回nil，系统的解决方案
    let pinId = "pinID"
    let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
    
    pinView.annotation = annotation
    // 是否显示标注
    pinView.canShowCallout = true
    // 设置大头针颜色
    pinView.pinColor = .purple
    // 设置大头针是否有下落动画
    pinView.animatesDrop = true
    return pinView
  }
  
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKCircleRenderer(overlay: overlay)
    renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
    renderer.strokeColor = UIColor.blue
    renderer.lineWidth = 2
    return renderer
  }
  
}
