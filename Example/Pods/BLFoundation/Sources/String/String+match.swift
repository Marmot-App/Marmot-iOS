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

// MARK: - Emoji
public extension String{

  /// 提取: Emojis
 public var emojis: [String] {
  let elements = unicodeScalars.compactMap { (scalar) -> String? in
      switch scalar.value {
      case 0x3030,
           0x00AE,
           0x00A9,
           0x1D000...0x1F77F,
           0x2100...0x278A,
           0x2793...0x27BF,
           0xFE00...0xFE0F,
           0x1F900...0x1F9FF:
        return String(scalar)
      default: return nil
      }
    }
    return elements
  }
  
 public func match(pattern: String) -> Bool {
    return self =~ pattern
  }
  
 public func match(pattern: RegexPattern) -> Bool {
    return self =~ pattern.pattern
  }
  
}


