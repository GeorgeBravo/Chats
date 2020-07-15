//
//  FileAsset.swift
//  Chats
//
//  Created by Mykhailo H on 7/14/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

public class FileAsset: NSObject, FileItem {
    public var data: Data
    
    public var fileName: String
    
    public var size: Double
    
    public var image: UIImage
    
    public init(fileName: String? = nil, data: Data? = nil, size: Double? = nil, image: UIImage? = nil) {
        self.data = data ?? Data()
        self.fileName = fileName ?? ""
        self.size = size ?? 0.0
        self.image = image ?? UIImage()
    }
}
