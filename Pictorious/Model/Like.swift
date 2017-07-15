//
//  Like.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase

class Like: ModelBase {
    
    static var collection:DatabaseReference {
        get {
            return Database.database().reference().child(kDataLikeKey)
        }
    }
    
    static func story(_ story:DatabaseReference!) {
        let likesRef = Like.collection
        
        if let userid = Auth.auth().currentUser?.uid {
            let likeRef = likesRef.child("\(story.key)/\(userid)")
            
            likeRef.updateChildValues(["liked":true])
            
            // store what I like
            UserProfile(userid).favorites.child(story.key).setValue(true)
        }
    }
    
    static func toggle(_ story:DatabaseReference!) {
        let likesRef = Like.collection
        
        if let userid = Auth.auth().currentUser?.uid {
            let likeRef = likesRef.child("\(story.key)/\(userid)")
            
            likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? [String:Any] {
                    let liked = value["liked"] as? Bool ?? false
                    likeRef.updateChildValues(["liked":!liked])
                    
                    // store what I like
                    if liked == false {
                        UserProfile(userid).favorites.child(story.key).setValue(true)
                    } else {
                        UserProfile(userid).favorites.child(story.key).removeValue()
                    }
                } else {
                    // if data not exist, set as liked
                    likeRef.updateChildValues(["liked":true])
                    UserProfile(userid).favorites.child(story.key).setValue(true)
                }
            })
        }
    }
    
    override func parent() -> DatabaseReference {
        return Like.collection
    }
    
    override func loadData(snap: DataSnapshot, with complete: @escaping (Bool) -> Void) {
        
    }
}
