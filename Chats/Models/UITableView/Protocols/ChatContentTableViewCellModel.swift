//
//  ChatContentTableViewCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 21.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

typealias MessageSelection = ((_ cellModel: ChatContentTableViewCellModel, _ cellNewFrame: CGRect) -> Void)

protocol ChatContentTableViewCellModel: ChatTableViewCellModel {
    var cellType: TableViewCellType! { get }
    
    var isMessageRead: Bool { get }
    var isIncomingMessage: Bool { get }
    var isMessageEdited: Bool { get }
    var messageSelection: MessageSelection? { get set }
    
    var timestamp: Date { get }
    var profileImage: UIImage? { get }
    var needHideMessage: Bool { get set }
    
    var chatType: ChatType { get }
    
    // MARK: - Logic
    func messageSelected(cellNewFrame: CGRect)
}

extension ChatContentTableViewCellModel {
    func messageSelected(cellNewFrame: CGRect) {
        messageSelection?(self, cellNewFrame)
    }
}
