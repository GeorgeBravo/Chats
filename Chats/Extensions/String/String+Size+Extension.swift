//
//  String+Size+Extension.swift
//  Chats
//
//  Created by user on 07.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

extension String {
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
