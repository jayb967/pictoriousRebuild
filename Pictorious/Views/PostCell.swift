//
//  PostCell.swift
//  Pictorious
//
//  Created by Jay Balderas on 7/26/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
    }
    
    //MARK: Post Section
    @IBOutlet weak var postTextField: UITextField!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
