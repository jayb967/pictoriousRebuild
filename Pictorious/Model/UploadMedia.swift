//
//  UploadMedia.swift
//  Pictorious
//
//  Created by Jay Balderas on 7/27/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import Foundation

class UploadMedia {
    
    var thumbnail:NSData?
    var media:NSData?
    var type:String = ".jpg"
    var caption:String = ""
    var hashtag:String = ""

    static let shared = UploadMedia()
    
    private init() {
        
    }
}
