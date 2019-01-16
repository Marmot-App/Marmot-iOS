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

public extension Timer {
  
  @discardableResult
  public final class func after(_ interval: TimeInterval, clourse: @escaping (Timer?) -> ()) -> Timer {
    var timer: Timer
    timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, 0, 0, 0, { (cfTimer) in
      clourse(cfTimer)
    })
    return timer
  }
  
  
  @discardableResult
  public final class func every(_ interval: TimeInterval, clourse: @escaping (Timer?) -> ()) -> Timer {
    var timer: Timer
    timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0, { (cfTimer) in
      clourse(cfTimer)
    })
    return timer
  }
  
  public final func start(runLoop: RunLoop = .current, modes: [RunLoop.Mode] = [RunLoop.Mode.default]) {
    modes.enumerated().reversed().forEach { (item) in
      runLoop.add(self, forMode: item.element)
    }
  }
}
