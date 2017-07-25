//
//  ChallengeCreateViewController.swift
//  Pictorious
//
//  Created by Jay Balderas on 7/23/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

class ChallengeCreateViewController: UIViewController {
    @IBOutlet weak var photoPreview: UIImageView!
    let imagePicker = UIImagePickerController()


    @IBOutlet weak var hashtagTextField: UITextField!
    @IBOutlet weak var placeholderTextLabel: UILabel!
    
    @IBOutlet weak var postChallengeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        postChallengeButton.layer.cornerRadius = 5
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openCamera()
    {
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
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }


}

extension ChallengeCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // use the image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension ChallengeCreateViewController{
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("backbutton pressed on Challengecreate VC")
    }
    @IBAction func ProposeButtonPressed(_ sender: UIButton) {
        createAlert(title: "Option Not yet Available.", message: "Coming Soon!")
    }
    @IBAction func EmptyPhotoPressed(_ sender: UITapGestureRecognizer) {
        
    }
    @IBAction func postChallengeButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func settingsSectionPressed(_ sender: UITapGestureRecognizer) {
        createAlert(title: "Option Not yet Available.", message: "Coming Soon!")
    }

}
