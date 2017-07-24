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

    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("backbutton pressed on Challengecreate VC")
    }
    @IBAction func ProposeButtonPressed(_ sender: UIButton) {
        createAlert(title: "Option Not yet Avilable.", message: "Coming Soon!")
    }
    @IBAction func EmptyPhotoPressed(_ sender: UITapGestureRecognizer) {
    
    }
    @IBAction func postChallengeButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func settingsSectionPressed(_ sender: UITapGestureRecognizer) {
        createAlert(title: "Option Not yet Avilable.", message: "Coming Soon!")
    }
    @IBOutlet weak var hashtagTextField: UITextField!
    @IBOutlet weak var placeholderTextLabel: UILabel!
    
    @IBOutlet weak var postChallengeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        postChallengeButton.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
