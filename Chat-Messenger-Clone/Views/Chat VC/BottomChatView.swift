//
//  BottomChatView.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/11/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit


protocol BottomChatViewDelegate {
  
  func sendMessage()
  func openCamera()
  func openGallery()
    
}



class BottomChatView: UIView {
  @IBOutlet weak var chatTextView: UITextView!
  @IBOutlet weak var chatTextViewLeading: NSLayoutConstraint!
  
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
  
  @IBOutlet weak var chatTextViewHeight: NSLayoutConstraint!
  var delegate: BottomChatViewDelegate?
  let maxHeightTextView: CGFloat = 70
  var minHeightTextView: CGFloat!
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let viewTemp = Bundle.main.loadNibNamed("BottomChatView", owner: self)?[0] as! UIView
    viewTemp.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(viewTemp)
    addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
    
    
    //    chatTextField.layer.borderWidth = 1.0
    //    chatTextField.layer.cornerRadius = 10
    chatTextView.layer.borderColor = UIColor.init(displayP3Red: 216/255, green: 217/255, blue: 219/255, alpha: 1.0).cgColor
    chatTextView.delegate = self
    minHeightTextView = chatTextView.frame.height
  }
  
  @IBAction func cameraClickButton(_ sender: Any) {
    
    delegate?.openCamera()
  }
  @IBAction func sendPressButton(_ sender: UIButton) {
    delegate?.sendMessage()
    sendButton.isEnabled = false
    
  }
  @IBAction func galleryClickButton(_ sender: Any) {
    delegate?.openGallery()
  }
  @IBAction func voiceClickButton(_ sender: Any) {
        print("click voice")
    }
}

extension BottomChatView: UITextViewDelegate {
    
    func chatTextViewHeightConstraint(height: CGFloat) {
        chatTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = height
            }
        }
    }
  func textViewDidChange(_ textView: UITextView) {
    if chatTextView.text.isEmpty {
        sendButton.isEnabled = false
    } else {
        sendButton.isEnabled = true
    }
    
    let size = CGSize(width: chatTextView.frame.width, height: .infinity)
    let eszimatedSize = chatTextView.sizeThatFits(size)
    
    var height = min(maxHeightTextView, eszimatedSize.height)
    height = max(height,minHeightTextView)
    chatTextViewHeight.constant = height
    
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    chatTextViewHeight.constant = minHeightTextView
    
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if chatTextView.text.isEmpty {
        sendButton.isEnabled = false
    } else {
        sendButton.isEnabled = true
    }
    let size = CGSize(width: chatTextView.frame.width, height: .infinity)
    let eszimatedSize = chatTextView.sizeThatFits(size)
    
    var height = min(maxHeightTextView, eszimatedSize.height)
    height = max(height,minHeightTextView)
    chatTextViewHeightConstraint(height: height)
    
    
  }
  
  
}



