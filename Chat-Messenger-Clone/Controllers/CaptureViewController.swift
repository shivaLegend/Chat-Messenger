//
//  CaptureViewController.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/14/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate {
//  var captureSession = AVCaptureSession();
//  var sessionOutput = AVCapturePhotoOutput();
//  var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG]);
//  var previewLayer = AVCaptureVideoPreviewLayer();
//
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    self.previewLayer.frame = self.view.frame
//    let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInDuoCamera, AVCaptureDevice.DeviceType.builtInTelephotoCamera,AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
//    for device in (deviceDiscoverySession.devices) {
//      if(device.position == AVCaptureDevice.Position.front){
//        do{
//          let input = try AVCaptureDeviceInput(device: device)
//          if(captureSession.canAddInput(input)){
//            captureSession.addInput(input);
//
//            if(captureSession.canAddOutput(sessionOutput)){
//              captureSession.addOutput(sessionOutput);
//              previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
//              previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
//              previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait;
//              self.view.layer.addSublayer(previewLayer);
//            }
//          }
//        }
//        catch{
//          print("exception!");
//        }
//      }
//    }
//  }
//
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    // Do any additional setup after loading the view.
//  }
}

extension CaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  
}
