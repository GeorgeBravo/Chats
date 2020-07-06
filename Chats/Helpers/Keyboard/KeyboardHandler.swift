//
//  KeyboardHandler.swift
//  SmartResident
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.

import UIKit

struct KeyboardInfo {
    let frame: CGRect
    let animationDuration: Double
    let animationCurve: UIView.AnimationOptions
    let isHidden: Bool

    init?(notification: Notification) {
        guard let frame = notification.keyboardFrame,
            let duration = notification.keyboardAnimationDuration,
            let curve = notification.keyboardAnimationCurve else {
            return nil
        }
        self.frame = frame
        self.animationDuration = duration
        self.animationCurve = curve
        self.isHidden = notification.name == UIResponder.keyboardWillHideNotification
    }
}

final class KeyboardHandler {
    typealias Completion = (_ keyboard: KeyboardInfo) -> Void

    private(set) weak var view: UIView?
    private(set) weak var targetScrollView: UIScrollView?

    var keyboardHandler: Completion?

    init(keyboardHandler: Completion? = nil) {
        self.keyboardHandler = keyboardHandler

        setNotifications()
    }

    init(view: UIView?, scrollView: UIScrollView?) {
        self.view = view
        self.targetScrollView = scrollView

        setNotifications()
    }

    private func setNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func Handler(_ info: KeyboardInfo) {
        guard let view = view, let scrollView = targetScrollView else { return }

        let endRect = view.convert(info.frame, to: view.window)
        let keyboardOverlap: CGFloat
        if #available(iOS 12, *) {
            keyboardOverlap = info.isHidden ? 0 : info.frame.height
        } else {
            keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
        }

        scrollView.contentInset.bottom = keyboardOverlap
        scrollView.scrollIndicatorInsets.bottom = keyboardOverlap

        UIView.animate(withDuration: info.animationDuration, delay: 0, options: info.animationCurve, animations: {
            view.layoutIfNeeded()
        })
    }

    @objc private func adjustForKeyboard(_ note: Notification) {
        guard let keyboardInfo = KeyboardInfo(notification: note) else { return }

        if let keyboardHandler = keyboardHandler {
            keyboardHandler(keyboardInfo)
        } else {
            Handler(keyboardInfo)
        }
    }
}

extension Notification {
    var keyboardFrame: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }

    var keyboardAnimationDuration: Double? {
        return userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
    }

    var keyboardAnimationCurve: UIView.AnimationOptions? {
        guard let value = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return nil }
        return UIView.AnimationOptions(rawValue: value)
    }
}
