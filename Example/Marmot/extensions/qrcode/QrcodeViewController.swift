


import UIKit
import SnapKit
import Stem
import AVFoundation
import Khala

class QrcodeViewController: UIViewController {
  
  lazy var captureSession: AVCaptureSession = {
    return  AVCaptureSession()
  }()
  
  let device = AVCaptureDevice.default(for: .video)
  
  lazy var videoPreviewLayer:AVCaptureVideoPreviewLayer = {
    let item = AVCaptureVideoPreviewLayer(session: captureSession)
    item.videoGravity = AVLayerVideoGravity.resizeAspectFill
    return item
  }()
  
  lazy var qrCodeFrameView: UIView = {
    // 初始化二维码选框并高亮边框
    let item = UIView()
    item.layer.borderColor = UIColor.green.cgColor
    item.layer.borderWidth = 2
    self.view.addSubview(item)
    self.view.bringSubviewToFront(item)
    return item
  }()
  
  lazy var messageLabel = UILabel()
  
  lazy var torchBtn: UIButton = {
    let item = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
    item.isHidden = true
    guard let image = UIImage(named: "torch") else { return item }
    item.setImage(image.st.setTint(color: UIColor.white), for: .normal)
    item.setImage(image.st.setTint(color: UIColor.lightGray), for: .highlighted)
    item.setImage(image.st.setTint(color: UIColor.green), for: .selected)
    item.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    item.setTitle("轻触点亮", for: .normal)
    item.setTitle("轻触关闭", for: .selected)
    item.st.verticalCenterImageAndTitle(spacing: 5)
    item.add(for: UIControl.Event.touchUpInside, action: {
      item.isSelected = !item.isSelected
      do{
        try self.device?.lockForConfiguration()
        self.device?.torchMode = item.isSelected ? .on : .off
        self.device?.unlockForConfiguration()
      }catch {
        print(error)
      }
    })
    self.view.addSubview(item)
    item.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.width.equalTo(item.width)
      make.height.equalTo(item.height)
    }
    return item
  }()
  
  
  var closure: KhalaClosure? = nil
  init(closure: @escaping KhalaClosure) {
    super.init(nibName: nil, bundle: nil)
    self.closure = closure
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    if let device = device,
      let input = try? AVCaptureDeviceInput(device: device),
      captureSession.canAddInput(input) {
      captureSession.addInput(input)
    }
    
    do {
      let output = AVCaptureVideoDataOutput()
      if captureSession.canAddOutput(output) {
        captureSession.addOutput(output)
      }
      output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
    }
    
    do {
      let output = AVCaptureMetadataOutput()
      if captureSession.canAddOutput(output) {
        captureSession.addOutput(output)
      }
      output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
    }
    
    
    
    videoPreviewLayer.frame = view.layer.bounds
    self.view.layer.addSublayer(videoPreviewLayer)
    
    // 开始视频捕获
    captureSession.startRunning()
    
    
    view.addSubview(messageLabel)
    messageLabel.frame = CGRect(x: 0, y: 60, width: 200, height: 80)
    
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    captureSession.stopRunning()
  }
  
  func authorization() {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
        granted ? self.configureCamera() : self.showErrorAlertView()
      })
    case .authorized:
      self.configureCamera()
    default:
      self.showErrorAlertView()
    }
  }
  
  func configureCamera() {
    
  }
  
  func showErrorAlertView() {
    
  }
  
  func turnTorch(on: Bool) {
    guard device?.hasTorch ?? false else { return }
    torchBtn.isHidden = !on && (device?.torchMode != .on)
  }
  
}

extension QrcodeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  
  public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard
      let dict = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
        as? [String: Any],
      let exifMetadata = dict[kCGImagePropertyExifDictionary as String] as? [String: Any],
      let brightnessValue = exifMetadata[kCGImagePropertyExifBrightnessValue as String] as? Double
      else { return }
    let brightnessThresholdValue = -0.2
    DispatchQueue.main.async { self.turnTorch(on: brightnessValue < brightnessThresholdValue) }
  }
  
}

extension QrcodeViewController: AVCaptureMetadataOutputObjectsDelegate {
  
  public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    // 检查：metadataObjects 对象不为空，并且至少包含一个元素
    if metadataObjects.isEmpty {
      qrCodeFrameView.frame = CGRect.zero
      messageLabel.text = "No QR code is detected"
      return
    }
    
    // 获得元数据对象
    let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
    
    if metadataObj.type == AVMetadataObject.ObjectType.qr {
      // 如果元数据是二维码，则更新二维码选框大小与 label 的文本
      let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: metadataObj)
      qrCodeFrameView.frame = barCodeObject!.bounds
      
      if metadataObj.stringValue != nil {
        closure?(["value": metadataObj.stringValue ?? ""])
        closure = nil
        self.dismiss(animated: true, completion: nil)
        self.st.pop(animated: true)
//        messageLabel.text = metadataObj.stringValue
      }
    }
  }
  
}
