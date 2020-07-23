//
//  Int+DecimalFormatted.swift
//  Chats
//
//  Created by Касилов Георгий on 21.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

extension Int {
    var decimalFormatted: String {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .decimal
        let formattedString = numberFormatter.string(from: NSNumber(value:self))
        
        return formattedString ?? String(self)
    }
}
