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

extension Stem where Base: NSLayoutConstraint {
  
  /// 改变Constant 增加或者减少
  /// - Parameter offSet: 变化量
  public func change(offest: CGFloat) {
    let nowConstant = base.constant
    base.constant = nowConstant + offest
  }
  
  /// 修改倍率
  ///
  /// - Parameter multiplier: 新倍率
  /// - Returns: Constraint
  public func change(multiplier: CGFloat) -> NSLayoutConstraint {
    NSLayoutConstraint.deactivate([base])
    
    let newConstraint = NSLayoutConstraint(
      item: base.firstItem as Any,
      attribute: base.firstAttribute,
      relatedBy: base.relation,
      toItem: base.secondItem,
      attribute: base.secondAttribute,
      multiplier: multiplier,
      constant: base.constant)
    
    newConstraint.priority = base.priority
    newConstraint.shouldBeArchived = base.shouldBeArchived
    newConstraint.identifier = base.identifier
    
    NSLayoutConstraint.activate([newConstraint])
    return newConstraint
  }
  
}
