//
//  AuthPickerViewController.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class AuthPickerViewController: FIRAuthPickerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let headerViews = Bundle.main.loadNibNamed("AuthLogoView", owner: self, options: nil)
        
        if let headerView = headerViews?.first as? UIView {
            self.view.addSubview(headerView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = self.title
    }
    
}

