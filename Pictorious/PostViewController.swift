//
//  PostViewController.swift
//  Pictorious
//
//  Created by Sergelenbaatar Tsogtbaatar on 7/27/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let imagePicker = UIImagePickerController()
    let upload = UploadMedia.shared
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var postCaptionTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        if upload.thumbnail != nil {
                
                //set textfieldsvar singleton
                if let caption = postCaptionTextField.text {
                    upload.caption = caption
                }
                
                //Instantiate uploading View Controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let createVC = storyboard.instantiateViewController(withIdentifier: "createVC") as! CreateViewController
                present(createVC, animated: true, completion: nil)
                
            
        } else{
            createAlert(title: "You need to add a photo!", message: "")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        shareButton.layer.cornerRadius = 7
        kStoryPostEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let image = UploadMedia.shared.croppedImage{
            imageView.image = image
            upload.thumbnail = UIImageJPEGRepresentation(image, kJPEGImageQuality) as NSData?
        } else {
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallary()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func openCamera() {
        
        kStoryPostEnabled = true
        
        self.dismiss(animated: false) { 
            let notificationName = Notification.Name("kNavCamera")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }

    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if "public.movie".compare(info[UIImagePickerControllerMediaType] as! String).rawValue == 0 {
            // for movie
            let video = info[UIImagePickerControllerMediaURL] as! URL
            let videoReference = info[UIImagePickerControllerReferenceURL] as! URL
            
            upload.media = NSData(contentsOf: video)!
            upload.type = ".mov"
            
            // generate thumbnail
            let asset = AVAsset(url: videoReference)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            var time = asset.duration
            //If possible - take not the first frame (it could be completely black or white on camara's videos)
            time.value = min(time.value, 2)
            
            if let imageRef = try? imageGenerator.copyCGImage(at: time, actualTime: nil) {
                let image = UIImage(cgImage: imageRef)
                imageView.image = image
                upload.thumbnail = UIImageJPEGRepresentation(image, kJPEGImageQuality) as NSData?
            }
        } else {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imageView.image = image
            upload.thumbnail = UIImageJPEGRepresentation(image, kJPEGImageQuality) as NSData?
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }


   

}
