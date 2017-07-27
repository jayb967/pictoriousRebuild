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
        if photoPreview != nil {
            
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
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        
        var media = upload.media!
        var type = upload.type
        var thumbnail = upload.thumbnail
        var caption = upload.caption
        var hashtag = upload.hashtag
        
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
        
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //use choseImage
        self.photoPreview.image = chosenImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

