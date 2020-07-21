//
//  ChatTableViewCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

typealias MessageSelection = ((_ cellModel: ChatTableViewCellModel, _ cellNewFrame: CGRect) -> Void)

protocol ChatTableViewCellModel: TableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { get }
    
    var isMessageRead: Bool { get }
    var isIncomingMessage: Bool { get }
    var isMessageEdited: Bool { get }
    var messageSelection: MessageSelection? { get set }
    
    var timestamp: Date { get }
    var profileImage: UIImage? { get }
    
    var chatType: ChatType { get }
    
    // MARK: - Logic
    func messageSelected(cellNewFrame: CGRect)
}

extension ChatTableViewCellModel {
    func messageSelected(cellNewFrame: CGRect) {
        messageSelection?(self, cellNewFrame)
    }
}
