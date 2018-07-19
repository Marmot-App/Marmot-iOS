//
//  calendar.swift
//  Marmot-iOS
//
//  Created by linhey on 2018/7/17.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

@objc(Router_calendar)
class Router_calendar: NSObject {
  
  @objc func router_fetch(params: [String: Any]) -> [String: Any]? {
    let eventStatus = EKEventStore.authorizationStatus(for: EKEntityType.event)
    
    //用户还没授权过
    if eventStatus == .notDetermined {
      //提示用户授权，调出授权弹窗
      EKEventStore().requestAccess(to: EKEntityType.event) { (res, error) in
        if res {
          print("允许")
        }else{
          print("拒绝授权")
          }
      }
    }

      //用户授权不允许
    else if eventStatus == .denied {
      
    }
    return nil
  }
  
}


