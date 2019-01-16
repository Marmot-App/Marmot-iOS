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

// MARK: - 设置ViewFarme相关属性
public extension UIView{

  /// view的x
  public var x: CGFloat{
    get{ return frame.origin.x }
    set{ self.frame.origin.x = newValue }
  }

  /// view的y
  public var y: CGFloat{
    get{ return frame.origin.y }
    set{ self.frame.origin.y = newValue }
  }
  
  public var minX: CGFloat {
    get{ return self.frame.minX }
    set{ self.x = newValue }
  }
  
  public var midX: CGFloat {
    get{ return self.frame.midX }
    set{ self.x = newValue - self.width * 0.5 }
  }
  
  public var maxX: CGFloat {
    get{ return self.frame.maxX }
    set{ self.x = newValue - self.width }
  }
  
  public var minY: CGFloat {
    get{ return self.frame.minY }
    set{ self.y = newValue }
  }
  
  public var midY: CGFloat {
    get{ return self.frame.midY }
    set{ self.y = newValue - self.height * 0.5 }
  }
  
  public var maxY: CGFloat {
    get{ return self.frame.maxY }
    set{ self.y = newValue - self.height }
  }

  /// view的宽度
  public var width: CGFloat {
    get{ return self.frame.size.width }
    set{ self.frame.size.width = newValue }
  }

  /// view的高度
  public var height: CGFloat {
    get{ return self.frame.size.height }
    set{ self.frame.size.height = newValue }
  }

  /// view的size
  public var size: CGSize{
    get{ return self.frame.size }
    set{ self.frame.size = newValue }
  }

  /// view的origin
  public var origin: CGPoint {
    get{ return self.frame.origin }
    set{ self.frame.origin = newValue }
  }
}
