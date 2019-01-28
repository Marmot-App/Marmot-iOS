//
//  MarmotURLRequest.swift
//  Marmot_Example
//
//  Created by linhey on 2019/1/26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import BLFoundation

class MarmotURLRequest: URLProtocol, URLSessionDelegate {
  
  fileprivate static let WebviewImageProtocolHandledKey = "WebviewImageProtocolHandledKey"
  
  override class func canInit(with request: URLRequest) -> Bool{
    guard let url = request.url?.absoluteString.lowercased() else { return false }
    let result = url.contains(".png") || url.contains(".jpg") || url.contains(".jpeg") || url.contains(".gif")
    guard result else { return false }
    guard (self.property(forKey: WebviewImageProtocolHandledKey, in: request) as? Bool ?? true) else {
      return false
    }
//    print(url)
    return true
  }
  
  override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
    super.init(request: request, cachedResponse: cachedResponse, client: client)
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest{
    return request
  }
  
  override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
    return super.requestIsCacheEquivalent(a, to: b)
  }
  
  static let cache: NSCache<NSString,NSData> = {
    let item = NSCache<NSString,NSData>()
    return item
  }()
  
  static let imagesPath: String = {
    let lib = NSSearchPathForDirectoriesInDomains(.libraryDirectory,.userDomainMask, true).first!
    print("\(lib)/com.marmot.linhey/images/")
    return "\(lib)/com.marmot.linhey/images/"
  }()
  
  override func startLoading() {
    //在磁盘上找到Kingfisher的缓存，则直接使用缓存
    func didLoad(with data: Data) {
      var mimeType = data.contentTypeForImageData()
      mimeType.append(";charset=UTF-8")
      let header = ["Content-Type": mimeType,
                    "Content-Length": String(data.count)]
      let response = HTTPURLResponse(url: self.request.url!, statusCode: 200, httpVersion: "1.1", headerFields: header)!
      self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
      self.client?.urlProtocol(self, didLoad: data)
      self.client?.urlProtocolDidFinishLoading(self)
    }
    
    
    func write(data: Data, key: String) {
      DispatchQueue.global().async {
        let fileManager = FileManager.default
        let path = MarmotURLRequest.imagesPath
        if !fileManager.fileExists(atPath: path) {
          do {
            try fileManager.createDirectory(atPath: path,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
          } catch _ {}
        }
        fileManager.createFile(atPath: path + key, contents: data, attributes: nil)
        print("cached: \(key)")
      }
    }
    
    guard let url = self.request.url else { return }
    let key = url.absoluteString.md5
    
    if let data = MarmotURLRequest.cache.object(forKey: key as NSString) as Data? {
      print("hitted: \(key)")
      didLoad(with: data)
      return
    }
    
    if let data = try? Data(contentsOf:URL(fileURLWithPath: MarmotURLRequest.imagesPath + key)) {
      print("hitted disk: \(key)")
      MarmotURLRequest.cache.setObject(data as NSData, forKey: key as NSString)
      didLoad(with: data)
      return
    }
    
    guard let request = (self.request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else { return }
    MarmotURLRequest.setProperty(true, forKey: MarmotURLRequest.WebviewImageProtocolHandledKey, in: request)
    URLSession(configuration: .default).dataTask(with: self.request, completionHandler: { (data, response, error) in
      print("caching: \(url)")
      if let error = error {
        self.client?.urlProtocol(self, didFailWithError: error)
        return
      }
      
      if let data = data, let response = response {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        self.client?.urlProtocol(self, didLoad: data)
        MarmotURLRequest.cache.setObject(data as NSData, forKey: key as NSString)
        write(data: data, key: key)
        return
      }
    }).resume()
  }
  
  
  override func stopLoading() {
  }
  
}


fileprivate extension Data {
  func contentTypeForImageData() -> String {
    var c:UInt8 = 0
    self.copyBytes(to: &c, count: MemoryLayout<UInt8>.size * 1)
    switch c {
    case 0xFF:
      return "image/jpeg";
    case 0x89:
      return "image/png";
    case 0x47:
      return "image/gif";
    default:
      return ""
    }
  }
}
