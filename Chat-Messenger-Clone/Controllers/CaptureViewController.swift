//
//  CaptureViewController.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/14/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit
import AVFoundation



class CaptureViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var sendImageView: UIImageView!
    @IBOutlet weak var outputImageView: UIImageView!
    @IBOutlet weak var outputView: UIView!
    
    
    
    // set url for video view
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    
    var videoURL: URL!
    var hasVideo: Bool = false
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
    
    
    //Switch camera
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
    
    //MARK: - Request access camera microphone
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
    
    // MARK: - Setup Capture session input & output for session
    func setupCaptureSession() {
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        let videoDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput) else {
            return
        }
        cameraDeviceInput = videoDeviceInput
        captureSession.addInput(videoDeviceInput)
        
        let microphoneDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInMicrophone, for: AVMediaType.audio, position: AVCaptureDevice.Position.unspecified)
        
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microphoneDevice!), captureSession.canAddInput(microphoneInput) else {
            return
        }
        
        captureSession.addInput(microphoneInput)
        
        
        photoOutput.isHighResolutionCaptureEnabled = true
        //    photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
        guard captureSession.canAddOutput(photoOutput) else {return}
        
        captureSession.addOutput(photoOutput)
        
        guard captureSession.canAddOutput(movieOutput) else {return}
        captureSession.addOutput(movieOutput)
        
        captureSession.commitConfiguration()
        
        setupPreview()
        
        captureSession.startRunning()
    }
    
    //MARK: - set up preview for screen
    func setupPreview() {
        self.previewLayer.session = self.captureSession
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        view.layer.addSublayer(previewLayer)
        view.bringSubviewToFront(closeButton)
        view.bringSubviewToFront(takePhotoButton)
        view.bringSubviewToFront(switchButton)
        
    }
    
    
    @IBAction func closeClickButton(_ sender: Any) {
        //click if it has video
        if hasVideo == true {
            print("LOL")
            hasVideo = false
            view.sendSubviewToBack(outputView)
        } else if self.outputImageView.image == nil { // if there don't have image
            self.dismiss(animated: true, completion: nil)
        } else {
            print("capture session again")
            self.outputImageView.image = nil
            view.sendSubviewToBack(outputView)
            
        }
    }
    
    @IBAction func tappedButton(_ sender: Any) {
        capturePhoto()
    }
    
    @IBAction func longPressedButton(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            
            initCricle()
            print("begin")
            startRecording()
            
        case .changed:
            print("change")
        case .cancelled,.ended,.failed:
            
            if movieOutput.isRecording == true {
                movieOutput.stopRecording()
                closeButton.imageView?.image = UIImage(named: "back")
            }
        default:
            print("Error long press")
        }
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
            cameraDeviceInput = videoDeviceInput
            captureSession.addInput(videoDeviceInput)
        } else {
            let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                      for: .video, position: .front)
            guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
                captureSession.canAddInput(videoDeviceInput)
                else { return }
            possionCamera = .front
            cameraDeviceInput = videoDeviceInput
            captureSession.addInput(videoDeviceInput)
        }
        
        //Commit all the configuration changes at once
        captureSession.commitConfiguration()
        
        let microPhoneDevice = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified)
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microPhoneDevice!), captureSession.canAddInput(microphoneInput) else {return}
        
        captureSession.startRunning()
        
    }
    
}

//MARK: - Capture photo Delegate
extension CaptureViewController: AVCapturePhotoCaptureDelegate {
    func capturePhoto() {
        
        let settings = AVCapturePhotoSettings()
        
        //set format for preview like main photo
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
           
            self.outputImageView.image = image
            closeButton.imageView?.image = UIImage(named: "back")
            bringViewToFront()
        }
        
    }
    
    func bringViewToFront() {
        view.bringSubviewToFront(sendImageView)
        view.bringSubviewToFront(outputView)
        view.bringSubviewToFront(closeButton)
    }
}

//MARK: - Capture Recording Video Delegate
extension CaptureViewController: AVCaptureFileOutputRecordingDelegate {
    //Add .mp4 for URL
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    //Orientation current
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
        }
        
        return orientation
    }
    
    //start Recording
    func startRecording() {
        
        if movieOutput.isRecording == false {
            
            let connection = movieOutput.connection(with: AVMediaType.video)
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
            }
            
            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            
            let device = cameraDeviceInput.device
            if (device.isSmoothAutoFocusSupported) {
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                } catch {
                    print("Error setting configuration: \(error)")
                }
                
            }
            
            //EDIT2: And I forgot this
            outputURL = tempURL()
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            
        }
        else {
            stopRecording()
        }
    }
    
    //StopRecording
    func stopRecording() {
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else { // if there have url video file
            hasVideo = true
            let videoRecorded = outputURL! as URL
            playVideoOutPut(videoRecorded: videoRecorded)
            bringViewToFront()
        }
    }
    
    //Set video play for output view
    func playVideoOutPut(videoRecorded: URL) {
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = outputView.bounds
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        outputView.layer.insertSublayer(avPlayerLayer, at: 0)
        
        view.layoutIfNeeded()
        
        let playerItem = AVPlayerItem(url: videoRecorded as URL)
        avPlayer.replaceCurrentItem(with: playerItem)
        
        avPlayer.play()
    }
}
//MARK: - Add circle function
extension CaptureViewController {    
    func initCricle() {
        
        let shapeLayer = CAShapeLayer()
        let center = takePhotoButton.center
        let circularPath = UIBezierPath(arcCenter: center, radius: takePhotoButton.frame.height/2, startAngle: CGFloat.pi*3/2, endAngle: CGFloat.pi*7/2, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 3
        basicAnimation.fillMode = .forwards
        
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
    }
    
}






