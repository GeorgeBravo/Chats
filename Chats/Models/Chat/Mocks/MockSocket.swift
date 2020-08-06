//
//  MockSocket.swift
//  MockSocket
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

final class MockSocket {
    
    static var shared = MockSocket()
    
    private var timer: Timer?
    
    private var queuedMessage: MockMessage?
    
    private var queuedMessages: [MockMessage]?
    
    private var onNewMessageCode: ((MockMessage) -> Void)?
    
    private var onTypingStatusCode: (() -> Void)?
    
    private var chatType: ChatType = .oneToOne
    
    private init() {}
    
    @discardableResult
    func connect(with chatType: ChatType) -> Self {
        self.chatType = chatType
        disconnect()
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        SampleData.shared.startTimer()
        return self
    }
    
    @discardableResult
    func disconnect() -> Self {
        SampleData.shared.stopTimer()
        timer?.invalidate()
        timer = nil
        onTypingStatusCode = nil
        onNewMessageCode = nil
        return self
    }
    
    @discardableResult
    func onNewMessage(code: @escaping (MockMessage) -> Void) -> Self {
        onNewMessageCode = code
        return self
    }
    
    @discardableResult
    func onTypingStatus(code: @escaping () -> Void) -> Self {
        onTypingStatusCode = code
        return self
    }
    
    @objc
    private func handleTimer() {
        if let message = queuedMessage {
            onNewMessageCode?(message)
            queuedMessage = nil
        } else {
            SampleData.shared.getMessages(count: 1, chatType: chatType) { (message) in
                queuedMessage = message.first
            }
            onTypingStatusCode?()
        }
    }
    
    @discardableResult
    func getDefaultHistory(code: @escaping ([MockMessage]) -> Void) -> Self {
        SampleData.shared.getMockedHistory(chatType: chatType) { (messgaes) in
            code(messgaes)
        }
        return self
    }
}
