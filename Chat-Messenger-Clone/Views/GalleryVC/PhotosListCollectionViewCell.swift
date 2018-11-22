//
//  PhotosListCollectionViewCell.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/22/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

class PhotosListCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                if wasClickImageView.image == UIImage(named: "unclick") {
                    wasClickImageView.image = UIImage(named: "click")
                } else {
                     wasClickImageView.image = UIImage(named: "unclick")
                }
            } 
        }
    }
    @IBOutlet weak var wasClickImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
