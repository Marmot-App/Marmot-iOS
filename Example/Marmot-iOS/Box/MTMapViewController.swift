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
  
  let mapView = MKMapView()
  let navView = UIButton()
  let okBtn = UIButton()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mapView)
    view.addSubview(navView)
    view.addSubview(okBtn)
//    let centerCoordinate = mapView.userLocation.coordinate
//    let span = MKCoordinateSpanMake(0.005, 0.005)
//    let region = MKCoordinateRegionMake(centerCoordinate, span)
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow
    mapView.delegate = self
    
//    mapView.region = region
    mapView.frame = view.bounds
    navView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    navView.backgroundColor = UIColor.blue
    navView.addTarget(self, action: #selector(close), for: UIControlEvents.touchUpInside)
    
    okBtn.setTitle("确定", for: UIControlState.normal)
    okBtn.addTarget(self, action: #selector(selectPoint), for: UIControlEvents.touchUpInside)
    okBtn.frame = CGRect(x: 300, y: 0, width: 200, height: 200)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent))
    mapView.addGestureRecognizer(tap)
  }
  
  @objc func tapEvent(ges: UITapGestureRecognizer) {
    let touchPoint = ges.location(in: mapView)
    let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
    let pointAnnotation = MKPointAnnotation()
    pointAnnotation.coordinate = touchMapCoordinate
    pointAnnotation.title = "a"
    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotation(pointAnnotation)
  }
  
  @objc func selectPoint() {
    dismiss(animated: true, completion: nil)
  }
  
 @objc func close() {
    dismiss(animated: true, completion: nil)
  }
  

}

extension MTMapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation { return nil }
    
    // 如果此方法返回nil, 就会使用系统自带的大头针视图
    // 模拟下，返回nil，系统的解决方案
    let pinId = "pinID"
    let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
    
    pinView.annotation = annotation
    // 是否显示标注
    pinView.canShowCallout = true
    // 设置大头针颜色
    pinView.pinColor = MKPinAnnotationColor.purple
    // 设置大头针是否有下落动画
    pinView.animatesDrop = true
    return pinView
  }
  
}
