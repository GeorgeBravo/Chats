//
//  ChatTransitionController.swift
//  Chats
//
//  Created by Eugene Zatserklyaniy on 26.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit


class ChatTransitionController: NSObject {
    
    let animator: ChatAnimator
    var isInteractive: Bool = false
    
    weak var fromDelegate: ChatAnimatorDelegate?
    weak var toDelegate: ChatAnimatorDelegate?
    
    init(duration: TimeInterval) {
        animator = ChatAnimator(duration: duration)
        super.init()
    }
}

extension ChatTransitionController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isPresenting = true
        self.animator.fromDelegate = fromDelegate
        self.animator.toDelegate = toDelegate
        return self.animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isPresenting = false
        self.animator.fromDelegate = self.toDelegate
        self.animator.toDelegate = fromDelegate
        return self.animator
    }
}
