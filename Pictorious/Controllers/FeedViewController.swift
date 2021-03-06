//
//  FeedViewController.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import AVFoundation
import DateToolsSwift

class CustomUITabBar: UITabBar, UITabBarControllerDelegate {
    
    static let scrollToTopNotification = Notification.Name("CustomUITabBar.scrollToTop")
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController == viewController {
            // scroll to top
            NotificationCenter.default.post(name: CustomUITabBar.scrollToTopNotification, object: nil)
        }
        
        return true
    }
    
    // TODO: uncomment if you wanna change tabbar height, default = 60
    //    override func sizeThatFits(size: CGSize) -> CGSize {
    //        let sizeThatFits = super.sizeThatFits(size)
    //        return CGSize(width: sizeThatFits.width, height: 60) <- TabBar Height in px
    //    }
}

class FeedViewController: UITableViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, StoryTableViewCellDelegate, UISearchResultsUpdating{
    
    var searchController:UISearchController!
    let searchResultsController = UITableViewController()
    
    var posts:[DataSnapshot] = []
    var searchResults:NSMutableArray = []
    var lastKey:DataSnapshot?
    var stopPaginationLoading:Bool = false
    var collection = Story.recents
    
    var newRef:DatabaseQuery?
    var oldRef:DatabaseQuery?
    
 
    // used to show only one story
    var singleStoryId:String?
    var searchbarHidden:Bool = false
    var beginUpdate:Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBOutlet weak var postSection: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - View cycle
    
    override func viewDidLoad() {
        
        self.tableView.estimatedRowHeight = 350
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        if searchbarEnabled() {
            // add searchbar to find users to follow
            self.searchResultsController.tableView.dataSource = self
            self.searchResultsController.tableView.delegate = self
            
            self.searchController = UISearchController(searchResultsController:self.searchResultsController)
            self.searchController.searchResultsUpdater = self
            
            self.tableView.tableHeaderView = self.searchController.searchBar
            
            // show personal feed
            self.collection = UserProfile.current!.feed
        } else {
            self.tableView.tableHeaderView = nil
        }
        
        // show personal feed
        self.stopPaginationLoading = true
        self.posts = []
        
        if beginUpdate {
            self.loadData()
            self.tableView.reloadData()
        }
        
        if searchbarEnabled() {
            self.tableView.contentOffset = CGPoint(x:0,y:self.searchController.searchBar.frame.size.height)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop),
                                               name: CustomUITabBar.scrollToTopNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: StoryTableViewCell.AutoplayMuteKey, object: nil)
        }
        
        NotificationCenter.default.removeObserver(self, name: CustomUITabBar.scrollToTopNotification, object: nil)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let lastIndex = self.tableView.indexPathsForVisibleRows?.last {
            if lastIndex.section >= self.posts.count - 2 {
                loadMore()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let commentsCtrl = segue.destination as? CommentsTableViewController {
            let story = sender as? DatabaseReference
            commentsCtrl.storyId = story?.key
        }
        
        if let profileCtrl = segue.destination as? ProfileFeedViewController {
            let user = sender as? DatabaseReference
            profileCtrl.user = user
        }
    }
    
    // MARK: - Data
    func searchbarEnabled() -> Bool {
        return kPersonalFeedEnabled && singleStoryId == nil && !searchbarHidden
    }
    
    func observeNewItems(_ firstKey:DataSnapshot?) {
        // Listen for new posts in the Firebase database
        newRef?.removeAllObservers()
        newRef = self.collection.queryOrderedByKey()
        
        if let startKey = firstKey?.key {
            newRef = newRef?.queryStarting(atValue: startKey)
        }
        
        // Listen for new posts in the Firebase database
        newRef?.observe(.childAdded, with: { (snapshot) in
            if snapshot.key != firstKey?.key {
                DispatchQueue.main.async(execute: {
                    self.posts.insert(snapshot, at: 0)
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func loadData() {
        if let storyId = singleStoryId {
            let ref = Story.collection.child(storyId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                DispatchQueue.main.async(execute: {
                    self.posts.insert(snapshot, at: 0)
                    self.stopPaginationLoading = true
                    print("Loaded \(snapshot.childrenCount) items")
                    
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
                
            }) { (error) in
                let alert = UIAlertController(title: kAlertErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: kAlertErrorDefaultButton, style: .default) { (action) in })
                self.present(alert, animated: true) {}
            }
            
        } else {
            let ref = self.collection
                .queryOrderedByKey()
                .queryLimited(toLast: kPagination)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                DispatchQueue.main.async(execute: {
                    for item in snapshot.children {
                        self.posts.insert(item as! DataSnapshot, at: 0)
                    }
                    
                    self.stopPaginationLoading = false
                    self.lastKey = snapshot.children.allObjects.first as? DataSnapshot
                    
                    let firstKey = snapshot.children.allObjects.last as? DataSnapshot
                    self.observeNewItems(firstKey)
                    
                    print("Loaded \(snapshot.childrenCount) items")
                    
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
                
            }) { (error) in
                let alert = UIAlertController(title: kAlertErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: kAlertErrorDefaultButton, style: .default) { (action) in })
                self.present(alert, animated: true) {}
            }
            
            // track for remove
            oldRef?.removeAllObservers()
            oldRef = self.collection
            oldRef?.observe(.childRemoved, with: { (snapshot) in
                DispatchQueue.main.async(execute: {
                    for item in self.posts {
                        if snapshot.key == item.key {
                            // remove item from collection
                            self.posts.remove(at: self.posts.index(of: item)!)
                        }
                    }
                    
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    func loadMore() {
        // load more
        if self.stopPaginationLoading == true || singleStoryId != nil {
            return
        }
        
        var refPagination = self.collection.queryOrderedByKey().queryLimited(toLast: kPagination + 1)
        
        if let last = self.lastKey {
            refPagination = refPagination.queryEnding(atValue: last.key)
            
            // load rest feed
            refPagination.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
                
                print("Loaded more \(snapshot.childrenCount) items")
                
                let items = snapshot.children.allObjects
                
                if items.count > 1 {
                    for i in 2...items.count {
                        let data = items[items.count-i] as! DataSnapshot
                        self.posts.append(data)
                    }
                    
                    self.lastKey = items.first as? DataSnapshot
                    self.tableView.reloadData()
                } else {
                    self.stopPaginationLoading = true
                    print("last item")
                }
            })
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        UserProfile.collection.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let results:NSMutableArray = []
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? [String:Any], let name = value["name"] as? String {
                    if name.lowercased().contains(searchController.searchBar.text!.lowercased()) {
                        results.add(UserProfile(child))
                    }
                }
            }
            
            self.searchResults = results
            self.searchResultsController.tableView.reloadData()
        })
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // reset states
        self.lastKey = nil
        self.stopPaginationLoading = true
        self.posts = []
        
        // reload data
        loadData()
    }
    
    func scrollToTop(notification:NSNotification) {
        if self.posts.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    // MARK: - TableView Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return self.posts.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return 1
        } else {
            return self.searchResults.count
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let postSectionIdentifier = "PostSection"
            let postSection = tableView.dequeueReusableCell(withIdentifier: postSectionIdentifier) as! PostCell
            return postSection
        } else
            if tableView == self.tableView {
                let view = tableView.dequeueReusableCell(withIdentifier: "Profile") as? UserTableViewCell
                let snap = self.posts[section]
                
                if let key = snap.value as? String {
                    view?.userRef = UserProfile(key).ref
                } else {
                    // compatibility with version 1.4 and less
                    let story = Story(snap.key)
                    story.fetchInBackground(completed: { (model, success) in
                        if success {
                            view?.userRef = story.userRef
                        }
                    })
                }
                
                view?.delegate = self
                return view
            } else {
                return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 119
        }
        if tableView == self.tableView {
            return 45
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            if kAutoplayVideo {
                if let storyCell = cell as? StoryTableViewCell {
                    storyCell.playerLayer?.player?.play()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            if let storyCell = cell as? StoryTableViewCell {
                storyCell.playerLayer?.player?.pause()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let identifier = "Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! StoryTableViewCell
            
            let snap = self.posts[indexPath.section]
            
            cell.storyRef = Story(snap.key).ref
            cell.delegate = self
            
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "User") as! UserTableViewCell
            if let userInfo = self.searchResults[indexPath.row] as? UserProfile {
                cell.userRef = userInfo.ref
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            // ..
        } else {
            // start follow
            if let selectedUser = self.searchResults[indexPath.row] as? UserProfile {
                
                if selectedUser.isFollow {
                    selectedUser.unfollow()
                } else {
                    selectedUser.follow()
                }
                
                // refresh cell
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
    // MARK: - Cell delegate
    
    func storyAction(_ data: DatabaseReference?) {
        if let story = data {
            Like.story(story)
        }
    }
    
    func storyDidLike(_ data: DatabaseReference?) {
        if let story = data {
            Like.toggle(story)
        }
    }
    
    func storyDidShare(_ data: DatabaseReference?) {
        
        if let ref = data {
            let story = Story(ref.key)
            
            story.fetchInBackground(completed: { (model, success) in
                
                // try to get image first
                var items:[Any] = []
                let imageManager = SDWebImageManager.shared()
                let imageCache = SDImageCache.shared()
                
                if story.videoUrl != nil {
                    items.append(story.videoUrl)
                } else {
                    let imageURL:URL = URL(string:story.media)!
                    
                    if imageManager.cachedImageExists(for: imageURL) != nil{
                        let cachedKey = imageManager.cacheKey(for: imageURL)
                        if let image = imageCache.imageFromDiskCache(forKey: cachedKey) {
                            items.append(image)
                        }
                    } else {
                        items.append(imageURL)
                    }
                }
                
                let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(activityViewController, animated: true) {
                    // ..
                }
                
            })
        }
    }
    
    func storyDidComment(_ data: DatabaseReference?) {
        self.performSegue(withIdentifier: "feed.comments", sender: data)
    }
//MARK: Post Buttons FeedVC
    @IBAction func createChallengeButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ChallengeCreate", bundle: nil)
        
        let createChallengeVC = storyboard.instantiateViewController(withIdentifier: "ChallengeCreate") as! ChallengeCreateViewController
        present(createChallengeVC, animated: true, completion: nil)
        
    }
    @IBAction func postPhotoButtonPressed(_ sender: UIButton) {
   
        
    
    }
    
    
}

extension FeedViewController : UserTableViewCellDelegate {
    func didSelected(userRef: DatabaseReference) {
        self.performSegue(withIdentifier: "show.profile", sender: userRef)
    }
}




