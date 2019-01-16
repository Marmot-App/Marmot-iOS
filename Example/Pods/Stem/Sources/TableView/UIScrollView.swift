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

extension UIScrollView {
  
 public enum ScrollDirection {
    case top
    case bottom
    case left
    case right
  }
  
}

public extension Stem where Base: UIScrollView {
  
  func scroll(to: UIScrollView.ScrollDirection, animated: Bool = true) {
    var off = base.contentOffset
    switch to {
    case .top:
      off.y = 0 - base.contentInset.top
    case .right:
      off.x = base.contentSize.width - base.bounds.size.width + base.contentInset.right
    case .left:
      off.x = 0 - base.contentInset.left
    case .bottom:
      off.y = base.contentSize.height - base.bounds.size.height + base.contentInset.bottom
    }
    base.setContentOffset(off, animated: animated)
  }
  
}
