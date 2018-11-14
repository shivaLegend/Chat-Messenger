//
//  ChatTableViewCell.swift
//  Chat-Messenger-Clone
//
//  Created by Nguyen Duc Tai on 11/11/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

  @IBOutlet weak var blueView: UIView!
  @IBOutlet weak var textLbl: UILabel!
  
  
  override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
