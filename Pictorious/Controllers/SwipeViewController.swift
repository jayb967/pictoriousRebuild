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
    override func viewDidLoad() {
        super .viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToProfileNon), name: Notification.Name("kNavProfileNon"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToHome), name: Notification.Name("kNavHome"), object: nil)
    }
    
    func moveToProfileNon() {
        
        moveToPage(2, animated: true)
    }
    func moveToHome() {
        
        moveToPage(1, animated: true)
    }
}

extension MySwipeVC: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let cameraVC = storyboard.instantiateViewController(withIdentifier: "CameraVC")
        
        let mainFeed = storyboard.instantiateViewController(withIdentifier: "mainTab")
        
        
        let profileFeed = storyboard.instantiateViewController(withIdentifier: "profileFeed")
        
        
//        let storeVC = storyboard.instantiateViewController(withIdentifier: "StoreVC")
        
        return [cameraVC, mainFeed, profileFeed]
    }
    //set view controller to center
    func indexOfStartingPage() -> Int {
        return 1
    }
    
}


