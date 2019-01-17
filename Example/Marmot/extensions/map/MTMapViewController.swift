//
//  MapViewController.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/20.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MapKit
import Khala
import SnapKit
import BLFoundation


class MTMapViewController: UIViewController {
  
   var mapView: MKMapView? = {
    let item = MKMapView()
    item.showsUserLocation = true
    item.showsBuildings = true
    if #available(iOS 9.0, *) {
      item.showsCompass = true
      item.showsScale = true
      item.showsTraffic = true
    }
    item.showsPointsOfInterest = true
    return item
    }()
  
  lazy var doneBtn: UIButton = {
    let item = UIButton()
    item.setTitle("确定", for: UIControl.State.normal)
    item.backgroundColor = UIColor.blue
    return item
    }()
  
  lazy var searchView: MTMapSearchView = {
    let item = MTMapSearchView()
    return item
    }()
  
  lazy var navigationView: MTMapNavigationView = {
    let item = MTMapNavigationView()
    return item
  }()
  
  
  lazy var annImageView: UIImageView = {
    let item = UIImageView(image: UIImage(named: "定位"))
    return item
    }()
  
  
  var mapZoomLevel = 0 {
    didSet{
      if mapZoomLevel == oldValue { return }
      applyMapViewMemoryHotFix()
    }
  }
  
  var closure: KhalaClosure?
  init(closure: @escaping KhalaClosure) {
    super.init(nibName: nil, bundle: nil)
    self.closure = closure
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
buildUI()
  }
  
  @objc func tapEvent(ges: UITapGestureRecognizer) {
    //    mapView.removeOverlays(mapView.overlays)
    //    let overlays = MKCircle(center: pointAnnotation.coordinate, radius: 100)
    //    mapView.add(overlays)
  }
  
  @objc func selectPoint() {
    dismiss(animated: true, completion: nil)
    if let lat = mapView?.centerCoordinate.latitude, let lng = mapView?.centerCoordinate.longitude {
      closure?(["lat": lat, "lng": lng])
      closure = nil
    }
    self.st.pop(animated: true)
  }
  
  @objc func close() {
    dismiss(animated: true, completion: nil)
    self.st.pop(animated: true)
  }
  
  
  
  deinit {
    // 内存释放
    mapView = nil
  }
  
}

extension MTMapViewController {
  
  private func buildUI() {
    view.backgroundColor = .white
    view.addSubview(mapView!)
    view.addSubview(doneBtn)
    view.addSubview(navigationView)
    buildLayout()
    buildSubviews()
  }
  
  private func buildLayout() {
    mapView!.snp.makeConstraints { (make) in
      make.top.equalTo(navigationView.snp.bottom)
      make.bottom.left.right.equalToSuperview()
    }
    
    navigationView.snp.makeConstraints { (make) in
      make.top.equalTo(self.topLayoutGuide.snp.bottom)
        make.left.right.equalToSuperview()
    }
    
    doneBtn.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().offset(-10)
      make.right.equalToSuperview().offset(-15)
      make.left.equalToSuperview().offset(15)
      make.height.equalTo(45)
    }
  }
  
  private func buildSubviews() {
    mapView!.delegate = self
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent))
    mapView!.addGestureRecognizer(tap)
    doneBtn.addTarget(self, action: #selector(selectPoint), for: .touchUpInside)
    navigationView.delegate = self
  }
  
  func initSearchView() {
    if searchView.superview != nil { return }
    view.addSubview(searchView)
    searchView.snp.makeConstraints { (make) in
      make.top.equalTo(navigationView.snp.bottom)
      make.bottom.left.right.equalToSuperview()
    }
    
    searchView.delegate = self
  }
  
}

extension MTMapViewController: MTMapSearchViewDelegate {
  
  func mapSearchView(didSelect coor: CLLocationCoordinate2D) {
    mapView?.setRegion(center: coor, zoomLevel: 18, animated: true)
  }
  
}

// MARK: - MTMapNavigationViewDelegate
extension MTMapViewController: MTMapNavigationViewDelegate {
  
  func mapNavigationView(view: MTMapNavigationView, cancelEvent: Bool) {
    searchView.isHidden = true
  }
  
  func mapNavigationView(view: MTMapNavigationView, closeEvent: Bool) {
    close()
  }
  
  func mapNavigationView(view: MTMapNavigationView, changed text: String) {
    searchView.key = text
  }
  
  func mapNavigationView(view: MTMapNavigationView, didBeginEdit: Bool) {
    initSearchView()
    searchView.isHidden = false
  }
}

extension MTMapViewController {
  
  // 地图缩放时内存暴涨
  private func applyMapViewMemoryHotFix() {
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
  
  private func execAnimation() {
    if annImageView.frame.origin == CGPoint.zero { return }
    let anim = CABasicAnimation()
    anim.keyPath = "position.y"
    anim.fromValue = annImageView.center.y
    anim.toValue = annImageView.center.y - 20
    anim.duration = 0.3
    anim.isRemovedOnCompletion = false
    anim.fillMode = CAMediaTimingFillMode.forwards
    
    let anim2 = CABasicAnimation()
    anim2.keyPath = "position.y"
    anim2.fromValue = annImageView.center.y - 20
    anim2.toValue = annImageView.center.y
    anim2.duration = 0.2
    anim2.beginTime = anim.duration
    anim2.isRemovedOnCompletion = false
    anim2.fillMode = CAMediaTimingFillMode.forwards
    
    let group = CAAnimationGroup()
    group.duration = anim.duration + anim2.duration
    group.animations = [anim,anim2]
    annImageView.layer.add(group, forKey: nil)
  }
  
  
  
  
  private func addAnnView(_ mapView: MKMapView) {
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
  
  
}

extension MTMapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    if annImageView.superview != nil { return }
    // 设置地图显示区域
    mapView.setRegion(center: userLocation.coordinate, zoomLevel: 18, animated: false)
    addAnnView(mapView)
  }
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    mapZoomLevel = mapView.currentZoomLevel
    execAnimation()
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
