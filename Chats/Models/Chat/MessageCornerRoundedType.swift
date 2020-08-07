//
//  MessageCornerRoundedType.swift
//  Chats
//
//  Created by user on 06.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let bigRadius: CGFloat = 20.0
    static let smallRadius: CGFloat = 5.0
}

enum MessageCornerRoundedType {
    case single
    case firstMessage
    case middleMessage
    case lastMessage
    
    static func random() -> MessageCornerRoundedType {
        let array: [MessageCornerRoundedType] = [.single, .firstMessage, .middleMessage, .lastMessage]
        let randomValue = array.random()!
        
        return randomValue
    }
    
    func getCorners(isIncomming: Bool) -> (topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        switch self {
        case .single, .firstMessage:
            let tl = getFirstMessageTopLeftCorners()
            let tr = getFirstMessageTopRightCorners()
            let bl = getFirstMessageBottomLeftCorners(isIncomming: isIncomming)
            let br = getFirstMessageBottomRightCorners(isIncomming: isIncomming)
            
            return (tl, tr, bl, br)
        case .lastMessage:
            let tl = getLastMessageTopLeftCorners(isIncomming: isIncomming)
            let tr = getLastMessageTopRightCorners(isIncomming: isIncomming)
            let bl = getLastMessageBottomLeftCorners()
            let br = getLastMessageBottomRightCorners()
            
            return (tl, tr, bl, br)
        case .middleMessage:
            let tl = getMiddleMessageTopLeftCorners(isIncomming: isIncomming)
            let tr = getMiddleMessageTopRightCorners(isIncomming: isIncomming)
            let bl = getMiddleMessageBottomLeftCorners(isIncomming: isIncomming)
            let br = getMiddleMessageBottomRightCorners(isIncomming: isIncomming)
            
            return (tl, tr, bl, br)
        }
    }
    
    private func getFirstMessageTopLeftCorners() -> CGFloat {
        return Constants.bigRadius
    }
    
    private func getFirstMessageTopRightCorners() -> CGFloat {
        return Constants.bigRadius
    }
    
    private func getFirstMessageBottomLeftCorners(isIncomming: Bool) -> CGFloat {
        switch isIncomming {
        case true:
            return Constants.smallRadius
        case false:
            return Constants.bigRadius
        }
    }
    
    private func getFirstMessageBottomRightCorners(isIncomming: Bool) -> CGFloat {
        switch isIncomming {
        case true:
            return Constants.bigRadius
        case false:
            return Constants.smallRadius
        }
    }
    
    private func getLastMessageTopLeftCorners(isIncomming: Bool) -> CGFloat {
        switch isIncomming {
        case true:
            return Constants.smallRadius
        case false:
            return Constants.bigRadius
        }
    }
    
    private func getLastMessageTopRightCorners(isIncomming: Bool) -> CGFloat {
        switch isIncomming {
        case true:
            return Constants.bigRadius
        case false:
            return Constants.smallRadius
        }
    }
    
    private func getLastMessageBottomLeftCorners() -> CGFloat {
        return Constants.bigRadius
    }
    
    private func getLastMessageBottomRightCorners() -> CGFloat {
        return Constants.bigRadius
    }
    
    private func getMiddleMessageTopLeftCorners(isIncomming: Bool) -> CGFloat {
        switch isIncomming {
        case true:
            return Constants.smallRadius
        case false:
            return Constants.bigRadius
        }
    }
    
    private func getMiddleMessageTopRightCorners(isIncomming: Bool) -> CGFloat {
        switch isIncomming {
        case true:
            return Constants.bigRadius
        case false:
            return Constants.smallRadius
        }
    }
    
    private func getMiddleMessageBottomLeftCorners(isIncomming: Bool) -> CGFloat {
        switch isIncomming {
        case true:
            return Constants.smallRadius
        case false:
            return Constants.bigRadius
        }
    }
    
    private func getMiddleMessageBottomRightCorners(isIncomming: Bool) -> CGFloat {
        switch isIncomming {
        case true:
            return Constants.bigRadius
        case false:
            return Constants.smallRadius
        }
    }
}
