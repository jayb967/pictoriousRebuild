//
//  ProfileViewController.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ThumbnailCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView?
}

class FavoriteFeedViewController : UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let feed = segue.destination as? FeedViewController, let user = Auth.auth().currentUser {
            feed.collection = UserProfile(user.uid).favorites
        }
    }
}

class ProfileViewController: UICollectionViewController {
    
    var activities:NSMutableArray = []
    var currentUser:UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            
            // load user profile and keep tracking update
            currentUser = UserProfile(user.uid)
            currentUser?.ref.observe(.value, with: { (snap) in
                self.currentUser?.loadData(snap: snap, with: { (success) in
                    self.collectionView?.reloadData()
                })
            })
            
            // load favorites/likes collection
            loadActivity(user.uid)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView?.reloadData()
    }
    
    func loadActivity(_ userId:String) {
        
        let favorites = Favorite.collection(userId)
        let ref = favorites.queryOrderedByKey()
        
        // bind items, and update collection
        ref.observe(.value, with: { (snapshot) -> Void in
            self.activities = NSMutableArray(array:snapshot.children.allObjects)
            self.collectionView?.reloadData()
        })
    }
    
    @IBAction func logOut() {
        try! Auth.auth().signOut()
        
        // show login page
        _ = self.tabBarController?.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Table view data source
    
    // Layout views in kFavoritesColumns columns
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.size.width/kFavoritesColumns - 1 // minus 1px padding
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var profileView:UICollectionReusableView! = nil
        
        if kind == UICollectionElementKindSectionHeader {
            profileView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Cell", for: indexPath)
            
            let profileImage = profileView.viewWithTag(1) as? ProfileView
            let profileTitle = profileView.viewWithTag(2) as? UILabel
            
            profileTitle?.text = currentUser?.name
            
            if let photo = URL(string:currentUser!.photo) {
                profileImage?.sd_setImage(with: photo, completed: { (image, error, cache, url) in
                    profileImage?.layoutSubviews()
                })
            }
        }
        
        return profileView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            as! ThumbnailCollectionViewCell
        
        // Configure the cell
        let r:DataSnapshot = self.activities.object(at: (indexPath as NSIndexPath).row) as! DataSnapshot
        let story = Story(r.key)
        
        story.fetchInBackground { (model, success) in
            cell.imageView?.sd_setIndicatorStyle(.gray)
            cell.imageView?.sd_setShowActivityIndicatorView(true)
            cell.imageView?.sd_setImage(with: URL(string:story.media))
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let feed = segue.destination as? StoryViewController {
            if let indexPath = self.collectionView?.indexPathsForSelectedItems?.first {
                let r:DataSnapshot = self.activities.object(at: (indexPath as NSIndexPath).row) as! DataSnapshot
                feed.storyId = r.key
            }
        }
    }
    
}

