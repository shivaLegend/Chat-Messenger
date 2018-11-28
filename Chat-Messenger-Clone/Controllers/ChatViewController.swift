//
//  ChatViewController.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/11/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var tableViewTopHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: BottomChatView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    @IBOutlet weak var ButttonRecord: UIButton!
    @IBOutlet weak var ButtonPlay: UIButton!
    
    var soundRecorder : AVAudioRecorder!
    var SoundPlayer : AVAudioPlayer!
    
    var imageArray = [UIImage]()
    
    var messages: [String] = []
    
    var minHeightTextView: CGFloat!
    
    
    
    var AudioFileName = "sound.m4a"
    
    
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),
                          AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(value: 1),
                          AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.alpha = 0.7
        minHeightTextView = bottomView.chatTextView.frame.height
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
            
            
        )
        
        for _ in 1...1000 {
            messages.append("If soul reincarnation is real, then with an increasing population, why doesn't the world run out of souls?")
        }
        
        bottomView.delegate = self
        
        chatTableView.delegate = self
        chatTableView.dataSource =  self
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil) , forCellReuseIdentifier: "ChatTableViewCell")
        chatTableView.transform = CGAffineTransform(rotationAngle: (-.pi))
        
        //add target table view cell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        
        chatTableView.addGestureRecognizer(tapGesture)
        
        //add long gesture for button voice
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(buttonVoiceLongTap(_:)))
        
        bottomView.voiceButton.addGestureRecognizer(longGesture)
        
        configureTableView()
        
        // Delegate and datasource for UICollectionView
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        
        requestAccessPhoto()
        grabPhotos()
        
        setupRecorder()
    }
    
    func recordAudio() {
        
        soundRecorder.record()
        
        
    }
    func stopAudio(){
        soundRecorder.stop()
        
    }
    func playAudio() {
        
        preparePlayer()
        SoundPlayer.play()
        
    }
    
    @objc func buttonVoiceLongTap(_ sender : UIGestureRecognizer){
        
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            stopAudio()
            playAudio()
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            recordAudio()
            
        } else if sender.state == .changed {
            print("gesture long changed")
            
        }
    }
    
    
    @objc func tableViewTapped() {
        bottomView.chatTextView.endEditing(true)
        //    tableViewTopHeight.constant = 0
        
        //    bottomView.chatTextFieldLeading.constant = 110
        //    UIView.animate(withDuration: 0.25) {
        //      self.view.layoutIfNeeded()
        //    }
    }
    
    func configureTableView() {
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 40
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            print("show keyboard is error")
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        
        guard let keyboardDuration: NSNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
            print("keyboard duration is error")
            return
        }
        
        guard let keyboardCurve: UInt = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            print("keyboard curve is error")
            return
        }
        
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        bottomViewBottom.constant = isKeyboardShowing ? keyboardHeight : 0
        bottomView.chatTextViewLeading.constant = isKeyboardShowing ? 10 : 110
        
        UIView.animate(withDuration: TimeInterval(truncating: keyboardDuration), delay: 0.0, options: UIView.AnimationOptions(rawValue: keyboardCurve), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    //MARK: - Access photo gallery
    func requestAccessPhoto() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    print("you accessed")
                    
                } else {
                    print("App need access photo library")
                    let alert = UIAlertController(title: "Photos Access Denied", message: "App needs access to photos library", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert,animated: true, completion: nil)
                }
            }
        } else if photos == .authorized {
            print("you accessed before")
            
        }
    }
    
    func grabPhotos() {
        imageArray = []
        DispatchQueue.global(qos: .background ).async {
            print("this is run on the background queue")
            
            let imgManager = PHImageManager.default()
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            print(fetchResult)
            print(fetchResult.count)
            
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width: (UIScreen.main.bounds.width - 10)/2, height: (UIScreen.main.bounds.width - 10)/2), contentMode: .aspectFit, options: requestOptions, resultHandler: { (image, error) in
                        self.imageArray.append(image!)
                    })
                }
            } else {
                print("There don't photos")
            }
        }
        DispatchQueue.main.async {
            self.galleryCollectionView.reloadData()
            print("reload data")
            
        }
        
    }
    
    @IBAction func listPhotoButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        vc.imageArray = self.imageArray
        present(vc,animated: true,completion: {
            self.bottomViewBottom.constant = 0
            UIView.animate(withDuration: 0.18, animations: {
                self.view.layoutIfNeeded()
            })
        })
        
        
    }
    
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        cell.textLbl.text = messages[indexPath.row]
        cell.transform = CGAffineTransform(rotationAngle: (-.pi))
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

//MARK: -UICollectionView Delegate & Datasource
extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count == 0 { //if imageArray still load
            return 100
        }
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        let tempImageView = UIImageView(image: UIImage(named: "picture"))
        cell.backgroundView = tempImageView
        if imageArray.count > 0 {
            
            let imageView = UIImageView(image: imageArray[indexPath.row])
            imageView.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 10)/2, height: (UIScreen.main.bounds.width - 10)/2)
            cell.addSubview(imageView)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 10)/2, height: (UIScreen.main.bounds.width - 10)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}
extension ChatViewController: BottomChatViewDelegate {
    func openVoice() {
        print("voice click")
    }
    func openGallery() {
        
        if bottomViewBottom.constant == 0 {
            view.bringSubviewToFront(galleryView)
            bottomViewBottom.constant = 226
        } else if bottomViewBottom.constant == 226 {
            bottomView.chatTextView.becomeFirstResponder()
            
        }
        UIView.animate(withDuration: 0.18) {
            self.view.layoutIfNeeded()
        }
        
    }
    func openCamera() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CaptureViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func sendMessage() {
        if !bottomView.chatTextView.text.isEmpty {
            let message = bottomView.chatTextView.text as String
            messages.insert(message, at: 0)
        }
        bottomView.chatTextView.text = ""
        bottomView.chatTextViewHeightConstraint(height: minHeightTextView)
        chatTableView.reloadData()
    }
    
}

extension ChatViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == chatTableView {
            if velocity.y > 0 {
                bottomViewBottom.constant = 0
                bottomView.chatTextView.resignFirstResponder()
            } else if velocity.y < 0 {
                print("<0")
            }
            UIView.animate(withDuration: 0.18) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension ChatViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    //HELPERS
    
    func preparePlayer(){
        
        do {
            try SoundPlayer = AVAudioPlayer(contentsOf: directoryURL()! as URL)
            SoundPlayer.delegate = self
            SoundPlayer.prepareToPlay()
            SoundPlayer.volume = 1.0
        } catch {
            print("Error playing")
        }
        
    }
    
    func setupRecorder(){
        
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        //ask for permission
        if audioSession.responds(to: #selector(AVAudioSession.requestRecordPermission(_:))){
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")
                    
                    //set category and activate recorder session
                    do {
                        
                        try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .default)
                        try self.soundRecorder = AVAudioRecorder(url: self.directoryURL()! as URL, settings: self.recordSettings)
                        self.soundRecorder.prepareToRecord()
                        
                    } catch {
                        
                        print("Error Recording");
                        
                    }
                    
                }
            })
        }
        
    }
    
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        return soundURL! as NSURL
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        ButtonPlay.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        ButttonRecord.isEnabled = true
        ButtonPlay.setTitle("Play", for: .normal)
    }
}

