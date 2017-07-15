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

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var progressView:UIProgressView?
    @IBOutlet weak var progressLabel:UILabel?
    
    var isPresented:Bool = false
    var previousTab:Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !isPresented {
            isPresented = true
            
            self.progressView?.isHidden = true
            self.progressLabel?.isHidden = true
            
            let picker:UIImagePickerController = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var thumbnail:NSData?
        var media:NSData?
        var type:String = ".jpg"
        
        if "public.movie".compare(info[UIImagePickerControllerMediaType] as! String).rawValue == 0 {
            // for movie
            let video = info[UIImagePickerControllerMediaURL] as! URL
            let videoReference = info[UIImagePickerControllerReferenceURL] as! URL
            
            media = NSData(contentsOf: video)!
            type = ".mov"
            
            // generate thumbnail
            let asset = AVAsset(url: videoReference)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            var time = asset.duration
            //If possible - take not the first frame (it could be completely black or white on camara's videos)
            time.value = min(time.value, 2)
            
            if let imageRef = try? imageGenerator.copyCGImage(at: time, actualTime: nil) {
                let image = UIImage(cgImage: imageRef)
                thumbnail = UIImageJPEGRepresentation(image, kJPEGImageQuality) as NSData?
            }
        } else {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            thumbnail = UIImageJPEGRepresentation(image, kJPEGImageQuality) as NSData?
        }
        
        if let data = thumbnail {
            self.progressView?.isHidden = false
            self.progressLabel?.isHidden = false
            
            // Data in memory
            let storage = Storage.storage().reference()
            
            // hide picker and show uploading process
            picker.dismiss(animated: true, completion: {})
            
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
                        self.tabBarController?.selectedIndex = 0 // home
                        self.isPresented = false
                    } else {
                        
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let url = metadata!.downloadURL()!.absoluteString
                        
                        if let video = media {
                            let videoref = storage.child("\(user.uid)-\(NSDate().timeIntervalSince1970)\(type)")
                            let videoMeta = StorageMetadata(dictionary: [ "contentType" : "video/quicktime"])
                            videoref.putData(video as Data, metadata: videoMeta) { metadata, error in
                                let videourl = metadata!.downloadURL()!.absoluteString
                                Story.createStory(user, url: url, video:videourl)
                            }
                        } else {
                            Story.createStory(user, url: url, video:"")
                        }
                        
                        self.progressView?.isHidden = true
                        self.progressLabel?.text = kMessageUploadingDone
                        
                        self.dismiss(animated: false, completion: nil)
                        self.tabBarController?.selectedIndex = 0 // home
                        self.isPresented = false
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: {
            self.tabBarController?.selectedIndex = 0 // home
            self.isPresented = false
        })
    }
    
}
