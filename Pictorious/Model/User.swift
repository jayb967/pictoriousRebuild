//
//  User.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserProfile: ModelBase {
    
    private static var _current:UserProfile?
    
    static var collection:DatabaseReference {
        get {
            return Database.database().reference().child(kUsersKey)
        }
    }
    
    static var current:UserProfile? {
        get {
            if let auth = Auth.auth().currentUser {
                if _current == nil || auth.uid != _current!.ref.key {
                    _current = UserProfile(auth.uid)
                    _current?.fetchInBackground(completed: { (model, success) in
                    })
                }
                
                return _current
            } else {
                return nil
            }
        }
    }
    
    private var _isFollowed:Bool = false
    
    var name:String = kDefaultUsername
    var photo:String = kDefaultProfilePhoto
    var isFollow:Bool {
        get { return _isFollowed }
    }
    
    // stories I posted
    var feed:DatabaseReference {
        get {
            return Database.database().reference().child("\(kUserFeedKey)/\(self.ref.key)")
        }
    }
    
    // posts I liked
    var favorites:DatabaseReference {
        get {
            return Database.database().reference().child("\(kDataFavoritesKey)/\(self.ref.key)")
        }
    }
    
    // followers - people who follow me
    var followers:DatabaseReference {
        get {
            return self.ref.child(kFollowersKey)
        }
    }
    
    // followigns - people followed by me
    var followings:DatabaseReference {
        get {
            return self.ref.child(kFollowinsKey)
        }
    }
    
    func follow() {
        if let current = UserProfile.current, self.ref.key != current.ref.key {
            current.followings.child(self.ref.key).setValue("true")
            self.followers.child(current.ref.key).setValue("true")
            _isFollowed = true
            
            fetchInBackground(completed: { (model, success) in
                // update data
            })
        }
    }
    
    func unfollow() {
        if let current = UserProfile.current, self.ref.key != current.ref.key {
            current.followings.child(self.ref.key).removeValue()
            self.followers.child(current.ref.key).removeValue()
            _isFollowed = false
            
            fetchInBackground(completed: { (model, success) in
                // update data
            })
        }
    }
    
    func isCurrent() -> Bool {
        if let current = UserProfile.current, self.ref.key != current.ref.key {
            return false
        } else {
            return true
        }
    }
    
    override func parent() -> DatabaseReference {
        return UserProfile.collection
    }
    
    override func loadData(snap: DataSnapshot, with complete: @escaping (Bool) -> Void) {
        if let value = snap.value as? [String:Any] {
            self.name = value["name"] as? String ?? kDefaultUsername
            self.photo = value["photo"] as? String ?? kDefaultProfilePhoto
            
            _isFollowed = snap.childSnapshot(forPath: "\(kFollowersKey)/\(UserProfile.current!.ref.key)").exists()
            
            complete(true)
        } else {
            complete(false)
        }
    }
    
    func saveData() {
        self.ref.updateChildValues(["name":self.name,
                                    "photo":self.photo])
    }
}
