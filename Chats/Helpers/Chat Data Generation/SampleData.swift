//
//  SampleData.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

final class SampleData {

    static let shared = SampleData()

    private init() {}

    enum MessageTypes: String, CaseIterable {
        case Text
        case Photo
        case Video
        case Audio
        case Location
        case ShareContact
    }

    private var now = Date()
    
    private var chatType: ChatType = .oneToOne
    
    private var timer: Timer?
    
    private var valueToAdd = 1
    
    private var shouldAddUserToChat = false
}

// MARK: - Message Generation
extension SampleData {
    private var dateAddingRandomTime: Date {
        return Date()
        let randomNumber = Int(arc4random_uniform(UInt32(10)))
        if randomNumber % 2 == 0 {
            let date = Calendar.current.date(byAdding: .minute, value: valueToAdd, to: Date())!
            now = date
            valueToAdd += 1
            return date
        } else {
            let randomMinute = Int(arc4random_uniform(UInt32(59)))
            let date = Calendar.current.date(byAdding: .minute, value: valueToAdd, to: Date())!
            now = date
            valueToAdd += 1
            return date
        }
    }

    func getMessages(count: Int, chatType: ChatType, completion: ([MockMessage]) -> Void) {
        
        self.chatType = chatType
        var messages: [MockMessage] = []
        
        if chatType == .group && shouldAddUserToChat {
            let userInviteModel = UserInviteModel(inviteeUserName: "Жорка", inviterUserName: arc4random_uniform(2) == 0 ? "Не Жорка" : nil)
            let message = MockMessage(model: userInviteModel, date: dateAddingRandomTime, chatType: chatType, messageId: UUID().uuidString)
            messages.append(message)
            shouldAddUserToChat = false
        } else {
            for _ in 0..<count {
                let date = dateAddingRandomTime
                let randomSentence = Lorem.sentence()
                let message = MockMessage(text: randomSentence, date: date, isIncomingMessage: arc4random_uniform(2) == 0, chatType: chatType, messageId: UUID().uuidString)
                messages.append(message)
            }
        }
     
        completion(messages)
    }
    
    // MARK: - Add new user to chat timer
    
    public func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 7.4, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func handleTimer() {
        self.shouldAddUserToChat = true
    }
}
