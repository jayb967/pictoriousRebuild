//
//  Comment.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase

class Comment : ModelBase {
    
    static var collection:DatabaseReference {
        get {
            return Database.database().reference().child(kDataCommentKey)
        }
    }
    
    static func sendComment(_ comment:String!, storyKey:String!) {
        
        let commentsRef:DatabaseReference = Comment.collection.child(storyKey)
        let key:String = commentsRef.childByAutoId().key
        
        if let user = UserProfile.current {
            let username:String = user.name
            let profilePhoto = user.photo
            let now = Date().format(with: kDateFormat)
            
            let post:[String:Any] = ["message": comment,
                                     "time" : now,
                                     "profile_id" : user.ref.key,
                                     "profile_name": username,
                                     "profile_image" : profilePhoto]
            
            let commentValues:[String:Any] = ["/\(key)": post]
            commentsRef.updateChildValues(commentValues)
        }
    }
    
    override func parent() -> DatabaseReference {
        return Comment.collection
    }
    
    override func loadData(snap: DataSnapshot, with complete: @escaping (Bool) -> Void) {
        // do nothing
    }
}
