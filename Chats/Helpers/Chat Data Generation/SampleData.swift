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
    
    private var firstCall: Bool = false
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
        if !firstCall {
            let unreadCellModel = UnreadMessagesModel(title: LocalizationKeys.unreadMessages.localized())
            let message = MockMessage(unreadModel: unreadCellModel, date: dateAddingRandomTime, chatType: chatType, messageId: UUID().uuidString)
            messages.append(message)
            firstCall = true
        }
        if chatType == .group && shouldAddUserToChat {
            let userInviteModel = UserInviteModel(inviteeUserName: "Жорка", inviterUserName: randomBool() ? "Не Жорка" : nil)
            let message = MockMessage(model: userInviteModel, date: dateAddingRandomTime, chatType: chatType, messageId: UUID().uuidString)
            messages.append(message)
            shouldAddUserToChat = false
        } else {
            for _ in 0..<count {
                let date = dateAddingRandomTime
                let randomSentence = Lorem.sentence()
                let message = MockMessage(text: randomSentence, date: date, isIncomingMessage: randomBool(), chatType: chatType, messageId: UUID().uuidString)
                messages.append(message)
            }
        }
     
        completion(messages)
    }
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    func getMockedHistory(chatType: ChatType, completion: ([MockMessage]) -> Void) {
        let date = dateAddingRandomTime
        let message1 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: false, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .firstMessage)
        let message2 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: false, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .middleMessage)
        let message3 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: false, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .lastMessage)
        let message4 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .single)
        let message5 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: false, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .firstMessage)
        let message6 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: false, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .lastMessage)
        let message7 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .firstMessage)
        let message8 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .lastMessage)
        let message9 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: false, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .firstMessage)
        let message10 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: false, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .middleMessage)
        let message11 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: false, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .middleMessage)
        let message12 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: false, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .lastMessage)
        let message13 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .firstMessage)
        let message14 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .middleMessage)
        let message15 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .lastMessage)
        let message16 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: false, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .single)
        let message17 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .firstMessage)
        let message18 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .middleMessage)
        let message19 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .middleMessage)
        let message20 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .middleMessage)
        let message21 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .middleMessage)
        let message22 = MockMessage(text: Lorem.sentence(), date: date, isIncomingMessage: true, chatType: chatType, messageId: UUID().uuidString, messageCornerRoundedType: .lastMessage)
        
        let mockedMessages = [message1, message2, message3, message4, message5, message6, message7, message8, message9, message10, message11, message12, message13, message14, message15, message16, message17, message18, message19, message20, message21, message22]
        completion(mockedMessages)
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
