//
//  BLFoundation
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import Foundation

/*
Class super_class                       OBJC2_UNAVAILABLE;  // 父类
const char *name                        OBJC2_UNAVAILABLE;  // 类名
long version                            OBJC2_UNAVAILABLE;  // 类的版本信息，默认为0
long info                               OBJC2_UNAVAILABLE;  // 类信息，供运行期使用的一些位标识
long instance_size                      OBJC2_UNAVAILABLE;  // 该类的实例变量大小
struct objc_ivar_list *ivars            OBJC2_UNAVAILABLE;  // 该类的成员变量链表
struct objc_method_list **methodLists   OBJC2_UNAVAILABLE;  // 方法定义的链表
struct objc_cache *cache                OBJC2_UNAVAILABLE;  // 方法缓存
struct objc_protocol_list *protocols    OBJC2_UNAVAILABLE;  // 协议链表
 */

class RunTimeClass {
  
  var `class`: AnyClass
  
  init(class type: AnyClass) {
    self.class = type
  }
  
  init?(class name: String) {
    guard let type = NSClassFromString(name) else { return nil }
      self.class = type
  }
  
  init?(register name: String, superclass: AnyClass? = NSObject.self) {
    guard let type =  objc_allocateClassPair(superclass, name, 0) else { return nil }
    //注册该类
    objc_registerClassPair(type)
    self.class = type
  }
  
  var super_class: AnyClass {
    set{ _ = class_setSuperclass(`class`, newValue) }
    get{ return class_getSuperclass(`class`)! }
  }
  
  var name: String {
    return String(cString: class_getName(`class`))
  }
  
  var version: Int {
    return Int(class_getVersion(`class`))
  }
  
  var instance_size: Int {
    return class_getInstanceSize(`class`)
  }
  
}
