//
//  UImage+other.swift
//  FBSnapshotTestCase
//
//  Created by linhey on 2019/1/12.
//

import UIKit


#if canImport(UIKit)
import CoreMedia

public extension UIImage{
  /// from CMSampleBuffer
  ///
  /// must import CoreMedia
  /// from: https://stackoverflow.com/questions/15726761/make-an-uiimage-from-a-cmsamplebuffer
  ///
  /// - Parameter sampleBuffer: CMSampleBuffer
  public convenience init?(sampleBuffer: CMSampleBuffer) {
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
    // Get the number of bytes per row for the pixel buffer
    let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
    // Get the number of bytes per row for the pixel buffer
    let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
    // Get the pixel buffer width and height
    let width = CVPixelBufferGetWidth(imageBuffer)
    let height = CVPixelBufferGetHeight(imageBuffer)
    // Create a device-dependent RGB color space
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    // Create a bitmap graphics context with the sample buffer data
    var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
    bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
    
    //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
    // Create a Quartz image from the pixel data in the bitmap graphics context
    guard let context = CGContext(data: baseAddress,
                                  width: width,
                                  height: height,
                                  bitsPerComponent: 8,
                                  bytesPerRow: bytesPerRow,
                                  space: colorSpace,
                                  bitmapInfo: bitmapInfo),
      let quartzImage = context.makeImage() else { return nil }
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
    // Create an image object from the Quartz image
    self.init(cgImage: quartzImage)
  }
  
}

#endif

public extension UIImage{
  
  public convenience init?(named: String, in bundle: Bundle) {
    let manager = FileManager.default
    guard let res = manager.enumerator(atPath: bundle.bundlePath)?
      .allObjects
      .compactMap({ (item) -> String? in
        return item as? String
      }).first(where: { (item) -> Bool in
        return item.components(separatedBy: "/").last?.components(separatedBy: ".").first == .some(named)
      }),
      let bundle = Bundle(path: bundle.bundlePath + res)
      else { return nil }
    self.init(named: named, in: bundle, compatibleWith: nil)
  }
  
}

public extension Stem where Base: UIImage {
  
  //  /// 高斯模糊
  //  ///
  //  /// - Parameter value: 0 ~ 100, 0为不模糊
  //  func blur(value: Double) -> UIImage? {
  //    let ciImage = CIImage(image: base)
  //    let filter = CIFilter(name: "CIGaussianBlur")
  //    filter?.setValue(ciImage, forKey: kCIInputImageKey)
  //    filter?.setValue(value, forKey: "inputRadius")
  //    guard let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
  //    let context = CIContext()
  //    guard let cgImage = context.createCGImage(output, from: output.extent) else { return nil }
  //    let image = UIImage(cgImage: cgImage)
  //    return image
  //  }
  
}
