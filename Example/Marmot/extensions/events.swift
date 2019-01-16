//
//  events.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Khala

@objc(MT_events) @objcMembers
class MT_events: UIResponder {
  
  private var shakeEvents = [KhalaClosure]()
  
  func shakeDetected(_ closure: @escaping KhalaClosure) {
    UIApplication.shared.applicationSupportsShakeToEdit = true
    self.becomeFirstResponder()
    shakeEvents.append(closure)
  }
  
  override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    
  }
  
  override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    
  }
  
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    shakeEvents.forEach { (closure) in
      closure([:])
    }
    shakeEvents.removeAll()
  }
  
}
