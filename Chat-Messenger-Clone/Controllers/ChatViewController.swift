//
//  ChatViewController.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/11/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
  
  
  @IBOutlet weak var tableViewTopHeight: NSLayoutConstraint!
  @IBOutlet weak var bottomView: BottomChatView!
  @IBOutlet weak var chatTableView: UITableView!
  @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
  
  enum ImageSource {
    case photoLibrary
    case camera
  }
  var messages: [String] = []
  
  var minHeightTextView: CGFloat!
  var imagePicker: UIImagePickerController!
  
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
    
    
  }
    
    @objc func buttonVoiceLongTap(_ sender : UIGestureRecognizer){
        
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            
            
        } else if sender.state == .changed {
            print("gesture long changed")
            print(sender.location(in: view.superview))
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


extension ChatViewController: BottomChatViewDelegate {

  
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

