//
//  Favorite.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase

class Favorite: ModelBase {
    
    static func collection(_ userId:String) -> DatabaseReference {
        return Database.database().reference().child("\(kDataFavoritesKey)/\(userId)")
    }
    
    override func parent() -> DatabaseReference {
        return Database.database().reference().child("\(kDataFavoritesKey)")
    }
    
    override func loadData(snap: DataSnapshot, with complete: @escaping (Bool) -> Void) {
    }
}
