//
//  ProfileView.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

class ProfileView: UIImageView {
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners()
    }
    
    // MARK: - Helper methods
    
    func setupView() {
        
        // default placeholder
        self.image = UIImage(named: "avatarPlaceholder")
        
        // set borders
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(white: 0.1, alpha: 0.1).cgColor
        
        // SDWebImage config
        self.sd_setIndicatorStyle(.gray)
        self.sd_setShowActivityIndicatorView(true)
    }
    
    func roundCorners() {
        self.layer.cornerRadius = self.frame.width/2
    }
    
}
