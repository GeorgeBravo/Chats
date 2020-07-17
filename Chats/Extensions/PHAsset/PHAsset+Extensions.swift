//
//  PHAsset+Extensions.swift
//  Chats
//
//  Created by Mykhailo H on 7/17/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import Photos
import UIKit

extension PHAsset {
    
    var image : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            thumbnail = image!
        })
        return thumbnail
    }
    
    var originalFilename: String? {
        
        var fname:String?
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        if fname == nil {
            // this is an undocumented workaround that works as of iOS 9.1
            fname = self.value(forKey: "filename") as? String
        }
        return fname
    }
}
