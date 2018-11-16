//
//  CaptureViewController.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/14/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit



class CaptureViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var tempButtom: UIButton!
    @IBOutlet weak var temp2Button: UIButton!
    
    //Input
    var cameraDeviceInput: AVCaptureDeviceInput!
    var microphoneDeviceInput: AVCaptureDeviceInput!
    
    //Output
    var capturePhotoOutput: AVCapturePhotoOutput!
    var captureMovieFileOutput: AVCaptureMovieFileOutput!
    var previewLayer =  AVCaptureVideoPreviewLayer()
    
    //Session
    var captureSession = AVCaptureSession()
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAuthorizationForCapture()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        print(captureSession.inputs.count)
        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else {return}
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
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
        
        
    }
    @IBAction func switchCameraClickButton(_ sender: Any) {
        
       
    }
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
   
    @IBAction func takeVideoClickButton(_ sender: Any) {
       
        
    }
    @IBAction func stopVideo(_ sender: Any) {
        
    }
    
}

extension CaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
   
}

extension CaptureViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        return
    }
   
    
}




