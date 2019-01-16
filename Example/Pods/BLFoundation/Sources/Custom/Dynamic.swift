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

/// http://rasic.info/bindings-generics-swift-and-mvvm/
/// 对象监听
public class Dynamic<T> {
  public typealias Listener = (T) -> Void
  public var listener: Listener?

  /// 监听
  ///
  /// - Parameter listener: 回调
  public func bind(listener: Listener?) {
    self.listener = listener
  }

  /// 监听并立马返回一次
  ///
  /// - Parameter listener: 回调
  public func bindAndFire(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
    
  /// 信号量, 防止多线程资源抢夺
  let semaphore = DispatchSemaphore(value: 1)
  
  var _value: T
  
  /// 值
  public var value: T {
    set{
      semaphore.wait()
      _value = newValue
      listener?(value)
      semaphore.signal()
    }
    get{
      return _value
    }
  }
  
  public init(_ v: T) {
    _value = v
  }
}
