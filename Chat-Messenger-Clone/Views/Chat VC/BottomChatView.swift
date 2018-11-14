//
//  BottomChatView.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/11/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit


protocol BottomChatViewDelegate {
    
    func sendMessage(message: String)
    func openCamera()
}



class BottomChatView: UIView {
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatTextViewLeading: NSLayoutConstraint!
    
    @IBOutlet weak var sendButton: UIButton!
    let maxHeightTextView: CGFloat = 70
    var minHeightTextView: CGFloat!
    var delegate: BottomChatViewDelegate?
    var message: String!
    var imagePicker: UIImagePickerController!
    
    var imageTake: UIImageView!
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
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
        minHeightTextView = chatTextView.frame.height
        chatTextView.delegate = self
    }
    
    @IBAction func cameraClickButton(_ sender: Any) {
        print("click")
        delegate?.openCamera()
    }
    @IBAction func sendPressButton(_ sender: UIButton) {
        
        if !chatTextView.text.isEmpty {
            message = chatTextView.text
            delegate?.sendMessage(message: message)
        }
        chatTextView.text = ""
        
        chatTextViewHeightConstraint(height: minHeightTextView)
        
        sendButton.isEnabled = false
    }
    
    // update height constrait
    func chatTextViewHeightConstraint(height: CGFloat) {
        chatTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = height
            }
        }
    }
    
}

extension BottomChatView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let eszimatedSize = textView.sizeThatFits(size)
        
        var height = min(maxHeightTextView, eszimatedSize.height)
        height = max(height,minHeightTextView)
        chatTextViewHeightConstraint(height: height)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        chatTextViewHeightConstraint(height: minHeightTextView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let eszimatedSize = textView.sizeThatFits(size)
        
        var height = min(maxHeightTextView, eszimatedSize.height)
        height = max(height,minHeightTextView)
        chatTextViewHeightConstraint(height: height)
        
    }
    
    
}



