//
//  BannerViewController.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BannerViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var bannerView:GADBannerView?
    @IBOutlet weak var bannerHeightConstraints: NSLayoutConstraint!
    
    @IBAction func hamburgerPressedButton(_ sender: UIButton) {
        createAlert(title: "Feature coming soon!", message: "")
    }
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        let notificationName = Notification.Name("kNavProfileNon")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    
    override func viewDidLoad() {
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        if kAdMobEnabled {
            print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
            
            if let bannerView = self.bannerView  {
                bannerView.adUnitID = kAdMobUnitID
                bannerView.rootViewController = self
                
                let request = GADRequest()
                request.testDevices = [kGADSimulatorID]
                bannerView.load(request)
            }
        } else {
            bannerHeightConstraints.constant = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
    }
    
}
