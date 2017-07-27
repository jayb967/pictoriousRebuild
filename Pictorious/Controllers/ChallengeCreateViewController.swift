//
//  ChallengeCreateViewController.swift
//  Pictorious
//
//  Created by Jay Balderas on 7/23/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ChallengeCreateViewController: UITableViewController, UIGestureRecognizerDelegate, UITextFieldDelegate  {
    let imagePicker = UIImagePickerController()
    let upload = UploadMedia.shared
    
    @IBOutlet weak var photoPreview: UIImageView!
    @IBOutlet weak var postChallengeButton: UIButton!

    @IBOutlet weak var hashtagTextField: UITextField!
    @IBOutlet weak var hastagLabel: UILabel!
   
    @IBOutlet weak var captionTextField: UITextView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        //clearing all media info out for future posts
        self.upload.caption = ""
        self.upload.hashtag = ""
        self.upload.media = nil
        self.upload.thumbnail = nil
        self.upload.type = ""
        self.upload.croppedImage = nil
        self.upload.image = nil
        
        kStoryPostEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func proposeButtonPressed(_ sender: UIButton) {
        createAlert(title: "Not yet Available!", message: "")
    }
    
    @IBAction func firstSwitchMoved(_ sender: UISwitch) {
        createAlert(title: "Feature Not yet Available!", message: "")
    }
    @IBAction func secondSwitchMoved(_ sender: UISwitch) {
        createAlert(title: "Feature Not yet Available!", message: "")
    }
    
    @IBAction func postChallegeButtonPressed(_ sender: UIButton) {
        if upload.thumbnail != nil {
            if hashtagTextField.text != "" {
                if captionTextField.text == "Write a caption for your challenge..."{
                    captionTextField.text = ""
                }
                //set textfields to singletons
                if let hashtag = hashtagTextField.text{
                    upload.hashtag = hashtag
                }
                
                if let caption = captionTextField.text {
                    upload.caption = caption
                }
                
                //Instantiate uploading View Controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let createVC = storyboard.instantiateViewController(withIdentifier: "createVC") as! CreateViewController
                present(createVC, animated: true, completion: nil)
                
            } else {
                createAlert(title: "You need to add a Challenge hashtag!", message: "")
            }
            
        } else{
            createAlert(title: "You need to add a photo!", message: "")
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        hashtagTextField.delegate = self
        captionTextField.delegate = self as? UITextViewDelegate
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.photoPreviewPressed(_:)))
        tap.delegate = self
        photoPreview.isUserInteractionEnabled = true
        photoPreview.addGestureRecognizer(tap)
        
        
        self.hideKeyboardWhenTappedAround()
        postChallengeButton.layer.cornerRadius = 7
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        
        if let image = UploadMedia.shared.croppedImage{
            photoPreview.image = image
            upload.thumbnail = UIImageJPEGRepresentation(image, kJPEGImageQuality) as NSData?
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         hastagLabel.text = String("#\(hashtagTextField.text!)")
    }
  
    
    func photoPreviewPressed(_ sender: UITapGestureRecognizer) {
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

    func openCamera() {
        kStoryPostEnabled = false
        
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
}

extension ChallengeCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                self.photoPreview.image = image
                upload.thumbnail = UIImageJPEGRepresentation(image, kJPEGImageQuality) as NSData?
            }
        } else {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.photoPreview.image = image
            upload.thumbnail = UIImageJPEGRepresentation(image, kJPEGImageQuality) as NSData?
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

