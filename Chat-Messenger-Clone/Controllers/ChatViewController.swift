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
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.alpha = 0.7
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        
        chatTableView.addGestureRecognizer(tapGesture)
        
        //add target table view cell
        
                configureTableView()
        
        
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

extension ChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        //        imageTake.image = selectedImage
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
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    
    func sendMessage(message: String) {
        messages.insert(message, at: 0)
        
        chatTableView.reloadData()
    }

}

