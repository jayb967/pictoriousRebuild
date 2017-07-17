//
//  Constants.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: Admob
/* Configure AdMob here by changing value. Please don't change the key */

let kAdMobEnabled = false

// TODO: Need to be changed
let kAdMobApplicationID = "ca-app-pub-3940256099942544~1458002511"
let kAdMobUnitID = "ca-app-pub-3940256099942544/2934735716"

// MARK: Configs

/* Feed generation mode: (you can change the mode any time)
 true - is show only followed users
 false - public feed, everyone see all posts
 */
let kPersonalFeedEnabled = true

/*
 The video is allowed in feed, but it shows a video player (if the first picture is black
 you will see black. Please use the autoplay (true) to play video on scrolling. The video will
 be streamed from server (not downloaded) so it used less network while scrolling.
 */
let kAutoplayVideo = true
/*
 Scale of video, you can choose one of these recommended:
 AVLayerVideoGravityResizeAspectFill - resize to fill the square
 AVLayerVideoGravityResizeAspect - resize to fit the square
 */
let kVideoScale = AVLayerVideoGravityResizeAspectFill

let kJPEGImageQuality:CGFloat = 0.4 // between 0..1
let kPagination:UInt = 1000
let kMaxConcurrentImageDownloads = 2 // the count of images donloading at the same time

let kLikeTapCount = 2 // you can like the photo by double tap on. number of taps
let kLikeTapAnimationDuration:TimeInterval = 0.3 // seconds
let kLikeTapAnimationScale:CGFloat = 3.0 // the max scale of heart to animate in seconds

let kPhotoShadowRadius:CGFloat = 10.0 // all photos has inner shadow on top and bottom
let kPhotoShadowColor:UIColor = UIColor(white: 0, alpha: 0.1)
let kProfilePhotoSize:CGFloat = 100 // px

let kCommentFontSize:CGFloat = 13.0 // points
let kFavoritesColumns:CGFloat = 3
let kDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

// MARK: Database
/*
 Change this values to set another firebase key path.
 Must be a non-empty string and not contain '.' '#' '$' '[' or ']'
 */

let kUserFeedKey = "user_feed"
let kUsersKey = "users"
let kFollowersKey = "followers"
let kFollowinsKey = "followings"
let kDataRecentsKey = "recents"
let kDataPostKey = "posts"
let kDataCommentKey = "comments"
let kDataLikeKey = "likes"
let kDataFavoritesKey = "activity"

// MARK: Strings
/*
 Localized text displayed to User
 */

let kDefaultUsername = NSLocalizedString("Mr. Mustage", comment: "Text used when username not set")
let kDefaultProfilePhoto = "" // url to default photo. will be stored in database

let kAlertErrorTitle = NSLocalizedString("Error", comment:"")
let kAlertErrorDefaultButton = NSLocalizedString("OK", comment:"")

let kMessageUploadingDone = NSLocalizedString("Done!", comment:"")
// example: Uploading: 12% (percentage will be added)
let kMessageUploadingProcess = NSLocalizedString("Uploading", comment:"")

