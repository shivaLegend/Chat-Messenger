//
//  CaptureViewController.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/14/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
  @IBOutlet weak var switchButton: UIButton!
  
    var captureSession = AVCaptureSession()
    //    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
    var previewLayer = AVCaptureVideoPreviewLayer()
    var takePhoto = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAccess()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = self.view.bounds
    }
    
    func requestAccess() {
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
        
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
      
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput)
            else {return}
        
        captureSession.addInput(videoDeviceInput)
      
        captureSession.sessionPreset = .photo
        
        previewLayer.session = self.captureSession
        
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        view.layer.addSublayer(previewLayer)
        view.bringSubviewToFront(closeButton)
        view.bringSubviewToFront(takePhotoButton)
        view.bringSubviewToFront(switchButton)
      
        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "tai")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
      
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if takePhoto {
            takePhoto = false
            //get image from sample buffer
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
                photoVC.takenPhoto = image
                DispatchQueue.main.async {
                    self.present(photoVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getImageFromSampleBuffer(buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
    
    @IBAction func closeClickButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cameraClickButton(_ sender: Any) {
       takePhoto = true
      
    }
  @IBAction func switchCameraClickButton(_ sender: Any) {
    
     let session = captureSession
      //Indicate that some changes will be made to the session
      session.beginConfiguration()
      
      //Remove existing input
      guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
        return
      }
      
      session.removeInput(currentCameraInput)
      
      //Get new input
      var newCamera: AVCaptureDevice! = nil
      if let input = currentCameraInput as? AVCaptureDeviceInput {
        if (input.device.position == .back) {
          newCamera = cameraWithPosition(position: .front)
        } else {
          newCamera = cameraWithPosition(position: .back)
        }
      }
      
      //Add input to session
      var err: NSError?
      var newVideoInput: AVCaptureDeviceInput!
      do {
        newVideoInput = try AVCaptureDeviceInput(device: newCamera)
      } catch let err1 as NSError {
        err = err1
        newVideoInput = nil
      }
      
      if newVideoInput == nil || err != nil {
        print("Error creating capture device input: \(String(describing: err?.localizedDescription))")
      } else {
        session.addInput(newVideoInput)
      }
      
      //Commit all the configuration changes at once
      session.commitConfiguration()
    
    let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    
    guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput)
      else {return}
      self.captureSession.addInput(videoDeviceInput)
    captureSession.startRunning()
  }
  // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
  func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
    for device in discoverySession.devices {
      if device.position == position {
        return device
      }
    }
    
    return nil
  }
  
    
}



