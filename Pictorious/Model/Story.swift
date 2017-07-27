//
//  Story.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Story : ModelBase {
    
    static var recents:DatabaseReference {
        get {
            return Database.database().reference().child(kDataRecentsKey)
        }
    }
    
    static var collection:DatabaseReference {
        get {
            return Database.database().reference().child(kDataPostKey)
        }
    }
    
    static func createStory(_ user:User, url:String, video:String, caption:String?, hashtag:String?) {
        
        // Create a reference to the file you want to upload
        let uid = user.uid
        let curUser = UserProfile(uid)
        let now = Date().format(with: kDateFormat)
        
        curUser.fetchInBackground { (model, success) in
            
            let post = ["user": uid,
                        "time" : now,
                        "image": url,
                        "video": video,
                        "message":"",
                        "caption": caption,
                        "hashtag": hashtag]
            
            // add to post collection
            var ref = Story.collection
            let key = ref.childByAutoId().key
            ref.updateChildValues(["/\(key)": post])
            
            // add to personal feed
            ref = curUser.feed
            ref.updateChildValues(["/\(key)": uid])
            
            if kPersonalFeedEnabled {
                // add to followers feed
                curUser.followers.observeSingleEvent(of: .value, with: { (snapshot) in
                    for item in snapshot.children.allObjects as! [DataSnapshot] {
                        UserProfile(item.key).feed.updateChildValues(["/\(key)": uid])
                    }
                })
            } else {
                // add to public feed
                ref = Story.recents
                ref.updateChildValues(["/\(key)": uid])
            }
        }
    }
    
    // MARK: - Model
    var userRef:DatabaseReference?
    
    var time:Date? = nil
    var media:String = ""
    var userId:String = ""
    var videoUrl:URL! = nil
    var caption:String = ""
    var hashtag:String = ""
    
    var userName:String = kDefaultUsername
    var userPhoto:String = kDefaultProfilePhoto
    
    override func parent() -> DatabaseReference {
        return Story.collection
    }
    
    override func loadData(snap: DataSnapshot, with complete:@escaping (Bool) -> Void) {
        
        if let value = snap.value as? [String:Any] {
            self.media = value["image"] as! String
            self.userId = value["user"] as! String
            
            if let caption = value["caption"] as? String {
                self.caption = caption
            }
            if let hashtag = value["hashtag"] as? String{
                self.hashtag = hashtag
            }
            if let timeString = value["time"] as? String {
                self.time = Date(dateString: timeString, format: kDateFormat)
            }
            
            if let videoAbsolute = value["video"] as? String {
                if videoAbsolute.characters.count > 0 {
                    self.videoUrl = URL(string: videoAbsolute)
                }
            }
            
            // remove previous observers
            userRef?.removeAllObservers()
            
            // add new observer
            userRef = UserProfile.collection.child(self.userId)
            userRef?.keepSynced(true)
            
            // update user_info and update in realtime
            userRef?.observe(.value, with: { (snap) in
                let user = UserProfile(snap)
                self.userName = user.name
                self.userPhoto = user.photo
            })
            
            complete(true)
        } else {
            complete(false)
        }
    }
    
    deinit {
        userRef?.removeAllObservers()
    }
}
