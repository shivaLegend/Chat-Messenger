//
//  PhotoViewController.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/15/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    
    var takenPhoto: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let availableImage = takenPhoto {
            imageView.image = availableImage
        }
    }
    

    @IBAction func backClickButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
