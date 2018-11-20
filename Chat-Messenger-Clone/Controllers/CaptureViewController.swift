//
//  CaptureViewController.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/14/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit
import AVFoundation

class CameraCaptureOutput: NSObject, AVCapturePhotoCaptureDelegate {
  
  let cameraOutput = AVCapturePhotoOutput()
  
  
}
  
  

class CaptureViewController: UIViewController {
  
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var takePhotoButton: UIButton!
  @IBOutlet weak var switchButton: UIButton!
  @IBOutlet weak var tempButtom: UIButton!
  @IBOutlet weak var temp2Button: UIButton!
  
  
  var takePhoto = false
  //Input
  var cameraDeviceInput: AVCaptureDeviceInput!
  var microphoneDeviceInput: AVCaptureDeviceInput!
  
  //Output
//  var capturePhotoOutput: AVCapturePhotoOutput!
  let movieOutput = AVCaptureMovieFileOutput()
  var previewLayer =  AVCaptureVideoPreviewLayer()
  var photoOutput = AVCapturePhotoOutput()
  var outputURL: URL!

  
  //Session
  var captureSession = AVCaptureSession()
  var photoSettting = AVCapturePhotoSettings()
  
  enum PossitionCamera {
    case front,back
  }
  var possionCamera: PossitionCamera = PossitionCamera.back
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    requestAuthorizationForCapture()
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    previewLayer.frame = self.view.bounds
  }
  
  func requestAuthorizationForCapture() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized: // The user has previously granted access to the camera.
      self.setupCaptureSession()
      
    case .notDetermined: // The user has not yet been asked for camera access.
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
          self.setupCaptureSession()
        }
      }
      
    case .denied: // The user has previously denied access.
      return
    case .restricted: // The user can't grant access due to restrictions.
      return
    }
  }
  
  func setupCaptureSession() {
    
    captureSession.beginConfiguration()
    
    let videoDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
    
    guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput) else {
      return
    }
    captureSession.addInput(videoDeviceInput)
    
    let microphoneDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInMicrophone, for: AVMediaType.audio, position: AVCaptureDevice.Position.unspecified)
    
    guard let microphoneInput = try? AVCaptureDeviceInput(device: microphoneDevice!), captureSession.canAddInput(microphoneInput) else {
      return
    }
    
    captureSession.addInput(microphoneInput)
    
    
    photoOutput.isHighResolutionCaptureEnabled = true
//    photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
    
    guard captureSession.canAddOutput(photoOutput) else {return}
    captureSession.sessionPreset = .photo
    captureSession.addOutput(photoOutput)
    
    guard captureSession.canAddOutput(movieOutput) else {return}
    captureSession.addOutput(movieOutput)
  
    captureSession.commitConfiguration()
    
    setupPreview()
    
    captureSession.startRunning()
  }
  
  func setupPreview() {
    self.previewLayer.session = self.captureSession
    self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    self.previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
    view.layer.addSublayer(previewLayer)
    view.bringSubviewToFront(closeButton)
    view.bringSubviewToFront(takePhotoButton)
    view.bringSubviewToFront(switchButton)
    view.bringSubviewToFront(tempButtom)
    view.bringSubviewToFront(temp2Button)
  }
  
  
  @IBAction func closeClickButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func cameraClickButton(_ sender: Any) {
      capturePhoto()
    
  }
  
  
  
  @IBAction func switchCameraClickButton(_ sender: Any) {
    //Indicate that some changes will be made to the session
    captureSession.beginConfiguration()
    
    for input in captureSession.inputs {
      captureSession.removeInput(input)
    }
    
    if possionCamera == .front {
      let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video, position: .back)
      guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
        captureSession.canAddInput(videoDeviceInput)
        else { return }
      possionCamera = .back
      captureSession.addInput(videoDeviceInput)
    } else {
      let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video, position: .front)
      guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
        captureSession.canAddInput(videoDeviceInput)
        else { return }
      possionCamera = .front
      captureSession.addInput(videoDeviceInput)
    }
    
    //Commit all the configuration changes at once
    captureSession.commitConfiguration()
    
    let microPhoneDevice = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified)
    guard let microphoneInput = try? AVCaptureDeviceInput(device: microPhoneDevice!), captureSession.canAddInput(microphoneInput) else {return}
    
    captureSession.startRunning()
    
  }
  // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
  
  @IBAction func takeVideoClickButton(_ sender: Any) {
    
    
  }
  @IBAction func stopVideo(_ sender: Any) {
    
  }
  
}

extension CaptureViewController: AVCapturePhotoCaptureDelegate {
  func capturePhoto() {
    
    let settings = AVCapturePhotoSettings()
    let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
    let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                         kCVPixelBufferWidthKey as String: 160,
                         kCVPixelBufferHeightKey as String: 160]
    settings.previewPhotoFormat = previewFormat
    self.photoOutput.capturePhoto(with: settings, delegate: self)
    
  }
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    if let error = error {
      print(error.localizedDescription)
    }
    
    if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
      print(UIImage(data: dataImage)!.size) // Your Image
      let image = UIImage(data: dataImage)
      let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
      photoVC.takenPhoto = image
      DispatchQueue.main.async {
        self.present(photoVC, animated: true, completion: nil)
      }
    }
    
  }
}

extension CaptureViewController: AVCaptureFileOutputRecordingDelegate {
  func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    if (error != nil) {
      print("Error recording movie: \(error!.localizedDescription)")
    } else {
      
      _ = outputURL as URL
      
    }
    outputURL = nil
  }
  
  
}






