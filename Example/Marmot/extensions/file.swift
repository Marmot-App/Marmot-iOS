//
//  file.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

@objc(MT_file) @objcMembers
class MT_file: NSObject {
  
  let manager = FileManager.default
  
  
  /// 读取文件
  func read(_ info: [String: Any]) -> [String: Any] {
    guard let path = info["path"] as? String else {
      return ["error":"can't paeser path"]
    }
    
    guard manager.fileExists(atPath: path) else {
      return ["error":"file not exists at path: \(path)"]
    }
    
    guard manager.isReadableFile(atPath: path) else {
      return["error": "can't read file at path: \(path)"]
    }
    
    do{
     let value = try String(contentsOfFile: path)
      return ["value": value]
    }catch{
      return ["error": error.localizedDescription]
    }
  }
  
}
