//
//  FileItem.swift
//  Chats
//
//  Created by Mykhailo H on 7/14/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

public protocol FileItem {
    var data: Data { get set }
    var fileName: String { get set }
    var size: Double { get set }
    var image: UIImage { get set }
}
