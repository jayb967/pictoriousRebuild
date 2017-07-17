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
    }
}

extension MySwipeVC: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        let redVC = UIViewController()
        redVC.view.backgroundColor = UIColor.red
        
        let mainFeed = storyboard.instantiateViewController(withIdentifier: "mainFeed")
        
        
        let blueVC = UIViewController()
        blueVC.view.backgroundColor = UIColor.blue
        
        
        let greenVC = UIViewController()
        greenVC.view.backgroundColor = UIColor.green
        
        return [redVC, blueVC, greenVC]
    }
    //set view controller to center
    func indexOfStartingPage() -> Int {
        return 2
    }
    
    func navigationBarDataForPageIndex(index: Int) -> UINavigationBar {
        var title = ""
        if index == 0 {
            title = "Charmander"
        } else if index == 1 {
            title = "Squirtle"
        } else if index == 2 {
            title = "Bulbasaur"
        }
        
        let navigationBar = UINavigationBar()
        navigationBar.barStyle = UIBarStyle.default
        //        navigationBar.barTintColor = QorumColors.WhiteLight
        print(navigationBar.barTintColor)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        let navigationItem = UINavigationItem(title: title)
        navigationItem.hidesBackButton = true
        
        if index == 0 {
            let rightButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: "a")
            rightButtonItem.tintColor = UIColor.black
            
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = rightButtonItem
        } else if index == 1 {
            let rightButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: "a")
            rightButtonItem.tintColor = UIColor.black
            
            let leftButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target: self, action: "a")
            leftButtonItem.tintColor = UIColor.black
            
            navigationItem.leftBarButtonItem = leftButtonItem
            navigationItem.rightBarButtonItem = rightButtonItem
        } else if index == 2 {
            let leftButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: "a")
            leftButtonItem.tintColor = UIColor.black
            
            navigationItem.leftBarButtonItem = leftButtonItem
            navigationItem.rightBarButtonItem = nil
        }
        navigationBar.pushItem(navigationItem, animated: false)
        return navigationBar
    }
}


