//
//  UITextField.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 12/3/19.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import UIKit

extension UITextField {
    func fixCaretPosition() {
        let beginning = beginningOfDocument
        selectedTextRange = textRange(from: beginning, to: beginning)

        let end = endOfDocument
        selectedTextRange = textRange(from: end, to: end)
    }
}
