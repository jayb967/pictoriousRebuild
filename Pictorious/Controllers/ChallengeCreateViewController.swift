//
//  ChallengeCreateViewController.swift
//  Pictorious
//
//  Created by Jay Balderas on 7/23/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

class ChallengeCreateViewController: UITableViewController, UIGestureRecognizerDelegate {
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var photoPreview: UIImageView!
    @IBOutlet weak var postChallengeButton: UIButton!
    @IBOutlet weak var hashtagTextField: UITextField!
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
        print("post Challenge pressed")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.photoPreviewPressed(_:)))
        tap.delegate = self
        photoPreview.isUserInteractionEnabled = true
        photoPreview.addGestureRecognizer(tap)
        
        self.hideKeyboardWhenTappedAround()
        postChallengeButton.layer.cornerRadius = 7
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
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //use choseImage
        self.photoPreview.image = chosenImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

