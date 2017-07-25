//
//  ImageFetcher.swift
//  Pictorious
//
//  Created by Jay Balderas on 7/24/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import Photos

public typealias ImageFetcherSuccess = (PHFetchResult<PHAsset>) -> ()
public typealias ImageFetcherFailure = (NSError) -> ()

public class ImageFetcher {
    
    private var success: ImageFetcherSuccess?
    private var failure: ImageFetcherFailure?
    
    private var authRequested = false
    private let errorDomain = "com.zero.imageFetcher"
    
    let libraryQueue = DispatchQueue(label: "com.zero.ALCameraViewController.LibraryQueue");
    
    public init() { }
    
    public func onSuccess(_ success: @escaping ImageFetcherSuccess) -> Self {
        self.success = success
        return self
    }
    
    public func onFailure(_ failure: @escaping ImageFetcherFailure) -> Self {
        self.failure = failure
        return self
    }
    
    public func fetch() -> Self {
        _ = PhotoLibraryAuthorizer { error in
            if error == nil {
                self.onAuthorized()
            } else {
                self.failure?(error!)
            }
        }
        return self
    }
    
    private func onAuthorized() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        libraryQueue.async {
            let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: options)
            DispatchQueue.main.async {
                self.success?(assets)
            }
        }
    }
}
