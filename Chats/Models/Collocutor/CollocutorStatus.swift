//
//  CollocutorStatus.swift
//  Chats
//
//  Created by Касилов Георгий on 30.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//
import UIKit

enum CollocutorStatus {
    case online
    case offline
    
    var stringDescription: String {
        switch self {
        case .online: return LocalizationKeys.online.localized()
        case .offline: return LocalizationKeys.offline.localized()
        }
    }
    
    var labelColor: UIColor {
        switch self {
        case .online: return UIColor(named: .aquamarine)
        case .offline: return UIColor(named: .steel)
        }
    }

}
