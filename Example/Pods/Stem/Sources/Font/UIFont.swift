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

extension UIFont {
  
  convenience init?(_ ctFont: CTFont) {
    let name = CTFontCopyPostScriptName(ctFont) as String
    guard !name.isEmpty else { return nil }
    let size = CTFontGetSize(ctFont)
    self.init(name: name, size: size)
  }
  
  convenience init?(cgFont: CGFont,size: CGFloat) {
    guard let cfName = cgFont.postScriptName else { return nil }
    let name = cfName as String
    guard !name.isEmpty else { return nil }
    self.init(name: name, size: size)
  }
  
  convenience init?(data: Data) {
    guard let provider = CGDataProvider(data: (data as CFData)), let cgFont = CGFont(provider) else { return nil }
    var error: Unmanaged<CFError>?
    guard CTFontManagerRegisterGraphicsFont(cgFont, &error),let fontName = cgFont.postScriptName else { return nil }
    self.init(name: fontName as String, size: UIFont.systemFontSize)
  }
  
}

public extension Stem where Base: UIFont {
  
  var isBold: Bool {
    return base.fontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue > 0
  }
  
  var isItalic: Bool {
    return base.fontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue > 0
  }
  
  var isMonoSpace: Bool {
    return base.fontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitMonoSpace.rawValue > 0
  }
  
  
  var isColorGlyphs: Bool {
    return CTFontGetSymbolicTraits(base as! CTFont).rawValue & CTFontSymbolicTraits.traitColorGlyphs.rawValue != 0
  }
  
  var weight: CGFloat {
    let dict = base.fontDescriptor.fontAttributes[.traits] as? [String: Any]
    return dict?[UIFontDescriptor.TraitKey.weight.rawValue] as? CGFloat ?? 0
  }
  
  var cgFont: CGFont? {
    return CGFont(base.fontName as CFString)
  }
  
}
