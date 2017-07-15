//
//  ModelBase.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/15/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Firebase

class ModelBase {
    
    var snapshot:DataSnapshot?
    var ref:DatabaseReference = Database.database().reference() // root ref as default
    
    var isDataLoaded:Bool = false
    
    // don't forget to call, fetchInBackground() to update data
    init(_ key:String) {
        self.ref = self.parent().child(key)
    }
    
    // instance can be created from data snapshot
    init(_ snap:DataSnapshot) {
        self.ref = snap.ref
        self.snapshot = snap
        
        loadData(snap: snap) { (success) in
            self.isDataLoaded = true
        }
    }
    
    /*
     Function to load data and store in Memory.
     In case of overriding, please call : complete() block
     */
    func fetchInBackground(completed block: @escaping (ModelBase, Bool) -> Void) -> Void {
        self.ref.observeSingleEvent(of: .value) { (snap:DataSnapshot) in
            self.snapshot = snap
            
            self.loadData(snap: snap, with: { (success) in
                self.isDataLoaded = true
                block(self, success)
            })
        }
    }
    
    // MARK: required to override
    
    func parent() -> DatabaseReference {
        fatalError("Subclass need to implement parent() as the reference")
    }
    
    func loadData(snap:DataSnapshot, with complete:@escaping (Bool) -> Void) {
        fatalError("Subclass need to implement loadData with correct snapshot")
    }
}
