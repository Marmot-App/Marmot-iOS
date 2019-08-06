//
//  Stem
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


import UIKit

public final class StemRuntime {
  
  /// 交换方法
  ///
  /// - Parameters:
  ///   - selector: 被交换的方法
  ///   - replace: 用于交换的方法
  ///   - classType: 所属类型
  public static func exchangeMethod(selector: Selector, replace: Selector, class classType: AnyClass) {
    let select1 = selector
    let select2 = replace
    let select1Method = class_getInstanceMethod(classType, select1)
    let select2Method = class_getInstanceMethod(classType, select2)
    let didAddMethod  = class_addMethod(classType,
                                        select1,
                                        method_getImplementation(select2Method!),
                                        method_getTypeEncoding(select2Method!))
    if didAddMethod {
      class_replaceMethod(classType,
                          select2,
                          method_getImplementation(select1Method!),
                          method_getTypeEncoding(select1Method!))
    }else {
      method_exchangeImplementations(select1Method!, select2Method!)
    }
  }
  
}
