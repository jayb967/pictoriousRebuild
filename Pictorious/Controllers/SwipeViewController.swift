//
//  SwipeViewController.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/17/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

class MySwipeVC: EZSwipeController {
    override func setupView() {
        datasource = self
        navigationBarShouldNotExist = true
    }
}

extension MySwipeVC: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let cameraVC = storyboard.instantiateViewController(withIdentifier: "CameraVC")
        
        let mainFeed = storyboard.instantiateViewController(withIdentifier: "mainTab")
        
        
        let profileFeed = storyboard.instantiateViewController(withIdentifier: "profileFeed")
        
        
        let storeVC = storyboard.instantiateViewController(withIdentifier: "StoreVC")
        
        return [cameraVC, mainFeed, storeVC, profileFeed]
    }
    //set view controller to center
    func indexOfStartingPage() -> Int {
        return 1
    }
    
}


