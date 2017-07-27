//
//  UploadMedia.swift
//  Pictorious
//
//  Created by Jay Balderas on 7/27/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import Foundation
import UIKit

class UploadMedia {
    
    var thumbnail:NSData?
    var media:NSData?
    var type:String = ".jpg"
    var caption:String = ""
    var hashtag:String = ""
    
    var image:UIImage?

    static let shared = UploadMedia()
    
    private init() {
        
    }
}
