//
//  CreateViewController.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices

class CreateViewController: UIViewController {
    
    @IBOutlet weak var progressView:UIProgressView?
    @IBOutlet weak var progressLabel:UILabel?
    
    let upload = UploadMedia.shared
    
    override func viewDidLoad() {
        super .viewDidLoad()
        uploadingMedia()
    }
    
    func uploadingMedia() {
        
        if let data = upload.thumbnail {
            self.progressView?.isHidden = false
            self.progressLabel?.isHidden = false
            
            // Data in memory
            let storage = Storage.storage().reference()
            
            if let user = Auth.auth().currentUser {
                let imgref = storage.child("\(user.uid)-\(NSDate().timeIntervalSince1970).jpg")
                let metadata = StorageMetadata(dictionary: [ "contentType" : "image/jpg"])
                
                
                // Upload the file to the path "media/"
                let uploadTask = imgref.putData(data as Data, metadata: metadata) { metadata, error in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        let alert = UIAlertController(title: kAlertErrorTitle, message: "Can't upload now. Please try later", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: kAlertErrorDefaultButton, style: .default) { (action) in })
                        self.present(alert, animated: true) {}
                    } else {
                        
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let url = metadata!.downloadURL()!.absoluteString
                        
                        if let video = self.upload.media {
                            let videoref = storage.child("\(user.uid)-\(NSDate().timeIntervalSince1970)\(self.upload.type)")
                            let videoMeta = StorageMetadata(dictionary: [ "contentType" : "video/quicktime"])
                            videoref.putData(video as Data, metadata: videoMeta) { metadata, error in
                                let videourl = metadata!.downloadURL()!.absoluteString
                                Story.createStory(user, url: url, video:videourl, caption: self.upload.caption, hashtag: self.upload.hashtag)
                            }
                        } else {
                            Story.createStory(user, url: url, video:"", caption: self.upload.caption, hashtag: self.upload.hashtag)
                        }
                        
                        self.progressView?.isHidden = true
                        self.progressLabel?.text = kMessageUploadingDone
                        
                        //clearing all media info out for future posts
                        self.upload.caption = ""
                        self.upload.hashtag = ""
                        self.upload.media = nil
                        self.upload.thumbnail = nil
                        self.upload.type = ""
                        
                        self.performSegue(withIdentifier: "afterUpload", sender: self)

                    }
                }
                
                uploadTask.observe(.progress) { snapshot in
                    // A progress event occurred
                    if let progress = snapshot.progress {
                        let complete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                        let percentComplete = Int(complete * 98) + 1 // never show 0% or 100%
                        self.progressView?.progress = Float(complete)
                        self.progressLabel?.text = "\(kMessageUploadingProcess): \(percentComplete)%"
                    }
                }
            }
            
        }
    }
    
}
