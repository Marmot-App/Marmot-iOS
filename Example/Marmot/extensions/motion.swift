//
//  motion.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CoreMotion
import Khala

/// 用于与系统自带的传感器交互，例如获取加速度
@objc(MT_motion) @objcMembers
class MT_motion: NSObject {
  
  let manager: CMMotionManager = {
    return CMMotionManager()
  }()
  
  func startUpdates(_ info: KhalaInfo, closure: @escaping KhalaClosure) -> KhalaInfo {
    guard manager.isDeviceMotionAvailable else { return ["error": "isDeviceMotionAvailable is false"] }
    if let updateInterval = info["updateInterval"] as? Double {
      manager.deviceMotionUpdateInterval = updateInterval
    }
    manager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
      guard let motion = motion else {
        closure(["error": error?.localizedDescription ?? ""])
        return
      }
      var result = KhalaInfo()
      result["attitude"] = [
        "yaw": motion.attitude.yaw,
        "pitch": motion.attitude.pitch,
        "roll": motion.attitude.roll,
        "quaternion": [
          "y": motion.attitude.quaternion.y,
          "x": motion.attitude.quaternion.x,
          "w": motion.attitude.quaternion.w,
          "z": motion.attitude.quaternion.z
        ],
        "rotationMatrix": [
          "m11":  motion.attitude.rotationMatrix.m11,
          "m12":  motion.attitude.rotationMatrix.m12,
          "m13":  motion.attitude.rotationMatrix.m13,
          "m21":  motion.attitude.rotationMatrix.m21,
          "m22":  motion.attitude.rotationMatrix.m22,
          "m23":  motion.attitude.rotationMatrix.m23,
          "m31":  motion.attitude.rotationMatrix.m31,
          "m32":  motion.attitude.rotationMatrix.m32,
          "m33":  motion.attitude.rotationMatrix.m33
        ]
      ]
      
      result["magneticField"] = [
        "accuracy": motion.magneticField.accuracy.rawValue,
        "field": [
          "x": motion.magneticField.field.x,
          "y": motion.magneticField.field.y,
          "z": motion.magneticField.field.z
        ]
      ]
      
      result["rotationRate"] = [
        "x": motion.rotationRate.x,
        "y": motion.rotationRate.y,
        "z": motion.rotationRate.z
      ]

      
      result["userAcceleration"] = [
        "x": motion.userAcceleration.x,
        "y": motion.userAcceleration.y,
        "z": motion.userAcceleration.z
      ]
      
      result["gravity"] = [
        "x": motion.gravity.x,
        "y": motion.gravity.y,
        "z": motion.gravity.z
      ]

      closure(result)
    }
    
    return [:]
  }
  
  func stopUpdates() {
    manager.stopDeviceMotionUpdates()
  }
  
}
