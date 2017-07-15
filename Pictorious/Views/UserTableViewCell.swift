//
//  UserTableViewCell.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase

protocol UserTableViewCellDelegate {
    func didSelected(userRef:DatabaseReference)
}

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileView: UIImageView?
    @IBOutlet weak var usernameView: UILabel?
    @IBOutlet weak var actionButton: UIButton?
    
    var delegate:UserTableViewCellDelegate?
    
    private var handler:UInt? = nil
    private var userCache:UserProfile?
    
    var userRef:DatabaseReference? {
        willSet {
            resetCell()
            
            // unsubscribe
            if let _handler = handler {
                userRef?.removeObserver(withHandle: _handler)
            }
        }
        didSet {
            // subscribe
            handler = userRef?.observe(.value, with: { (snapshot) in
                let user = UserProfile(snapshot)
                self.setupCell(user: user)
            })
        }
    }
    
    private func resetCell() {
        self.usernameView?.text = kDefaultUsername
        self.profileView?.image = #imageLiteral(resourceName: "avatarPlaceholder")
        self.actionButton?.isHidden = true
    }
    
    private func setupCell(user:UserProfile) {
        self.userCache = user
        let placeholder = UIImage(named: "avatarPlaceholder")!
        
        // user name
        self.usernameView?.text = user.name
        
        // user profile photo
        self.profileView?.sd_cancelCurrentImageLoad()
        self.profileView?.sd_setImage(with: URL(string:user.photo), placeholderImage: placeholder)
        
        // follow/unfollow button
        self.actionButton?.isHidden = user.isCurrent()
        self.actionButton?.isSelected = user.isFollow
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resetCell()
        
        // setup onclick action
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onDisplayProfile))
        self.addGestureRecognizer(recognizer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func onDisplayProfile() {
        if let ref = self.userRef {
            self.delegate?.didSelected(userRef: ref)
        }
    }
    
    @IBAction func actionButton(sender:Any) {
        // follow/unfollow user
        if let user = userCache {
            if user.isFollow {
                user.unfollow()
            } else {
                user.follow()
            }
        }
    }
}
