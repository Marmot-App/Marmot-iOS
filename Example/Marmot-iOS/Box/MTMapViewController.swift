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

class MTMapViewController: UIViewController {
  
  lazy var mapView: MKMapView = { [weak self] in
    guard let base = self else { return MKMapView() }
    let item = MKMapView()
    item.showsUserLocation = true
    item.userTrackingMode = .follow
    item.delegate = base
    item.frame = view.bounds
    
    
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
  
  lazy var okBtn: UIButton = { [weak self] in
    guard let base = self else { return UIButton() }
    let item = UIButton()
    item.setTitle("确定", for: UIControlState.normal)
    item.addTarget(base, action: #selector(selectPoint), for: .touchUpInside)
    item.frame = CGRect(x: 15,
                        y: base.view.bounds.height - 15 - 45,
                        width: base.view.bounds.width - 15 - 15,
                        height: 45)
    item.backgroundColor = UIColor.blue
    return item
    }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mapView)
    view.addSubview(okBtn)
  }
  
  @objc func tapEvent(ges: UITapGestureRecognizer) {
    mapView.removeAnnotations(mapView.annotations)
    let touchPoint = ges.location(in: mapView)
    let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
    let pointAnnotation = MKPointAnnotation()
    pointAnnotation.coordinate = touchMapCoordinate
    pointAnnotation.title = "a"
    mapView.addAnnotation(pointAnnotation)
    
    mapView.removeOverlays(mapView.overlays)
    let overlays = MKCircle(center: pointAnnotation.coordinate, radius: 100)
    mapView.add(overlays)
  }
  
  @objc func selectPoint() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func close() {
    dismiss(animated: true, completion: nil)
  }
  
  
}

extension MTMapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    // 设置地图显示区域
    let center = (userLocation.coordinate)
    let span = MKCoordinateSpanMake(0.0219952102009202, 0.0160932558432023)
    let region: MKCoordinateRegion = MKCoordinateRegionMake(center, span)
    mapView.setRegion(region, animated: true)
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
