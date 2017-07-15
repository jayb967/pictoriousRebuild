//
//  StoryViewController.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase

class StoryViewController: UIViewController {
    
    var storyId:String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let feed = segue.destination as? FeedViewController {
            feed.singleStoryId = self.storyId
        }
    }
}
