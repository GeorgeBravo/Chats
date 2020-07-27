//
//  UINavigationItem+Extensions.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let bigSizeFont: CGFloat = 21
    static let mediumSizeFont: CGFloat = 17
    static let smallSizeFont: CGFloat = 14
    static let avatarSizeHeight: CGFloat = 40
}

extension UINavigationItem {
    func setLeftTextButtonItems(text: String, target: Any?, action: Selector?) {
        let textLeftBarItem = leftTextItem(
            with: text, additionalText: nil,
            target: target, action: action
        )
        leftItemsSupplementBackButton = true
        setLeftBarButtonItems([textLeftBarItem], animated: false)
    }
    
    func setLeftOneToOneChatButtonItems(
        text: String, additionalText: String?,
        imageUrl: String?,
        target: Any, action: Selector
    ) {
        let textItem = leftTextItem(
            with: text, additionalText: additionalText,
            bigSize: false,
            target: target, action: action
        )
        let imageItem = avatarBarButtonItem(
            imageStringUrl: imageUrl,
            target: target, action: action
        )
        leftItemsSupplementBackButton = true
        setLeftBarButtonItems([imageItem, textItem], animated: false)
    }
    
    private func setLeftTextItem(
        text: String,
        target: Any, action: Selector
    ) {
        setLeftBarButton(leftTextItem(
            with: text, additionalText: nil,
            target: target, action: action
        ), animated: false)
    }
    
    private func leftTextItem(
        with text: String, additionalText: String?,
        bigSize: Bool = true,
        target: Any?, action: Selector?
    ) -> UIBarButtonItem {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0
        let textItemLabel = UILabel()
        textItemLabel.isUserInteractionEnabled = false
        textItemLabel.text = text
        textItemLabel.textColor = .white
        textItemLabel.sizeToFit()
        textItemLabel.font = UIFont.boldSystemFont(ofSize: bigSize ? 21.0 : additionalText == nil ? 17.0 : 14.0)
        stackView.addArrangedSubview(textItemLabel)
        if (additionalText?.isEmpty ?? true) == false  {
            let subtitleLabel = UILabel()
            subtitleLabel.isUserInteractionEnabled = false
            subtitleLabel.textColor = .white
            subtitleLabel.text = additionalText
            subtitleLabel.font = UIFont.systemFont(ofSize: 12)
            stackView.addArrangedSubview(subtitleLabel)
        }
        let control = UIControl()
        if let target = target, let action = action {
            control.addTarget(target, action: action, for: .touchUpInside)
            stackView.isUserInteractionEnabled = false
        }
        control.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: control.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: control.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: control.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: control.bottomAnchor),
        ])
        return UIBarButtonItem(customView: control)
    }
    
    private func avatarBarButtonItem(
        imageStringUrl: String?,
        target: Any, action: Selector
    ) -> UIBarButtonItem {
        let control = UIControl()
        control.isUserInteractionEnabled = true
        control.addTarget(target, action: action, for: .touchUpInside)
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        control.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: control.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: control.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: control.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: control.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.avatarSizeHeight),
            imageView.widthAnchor.constraint(equalToConstant: Constants.avatarSizeHeight)
        ])
//        imageView.setImageAsync(
//            url: imageStringUrl,
//            placeholderImage: #imageLiteral(resourceName: "userIcon"),
//            startContentMode: .scaleAspectFill,
//            finishContentMode: .scaleAspectFill
//        )
        control.frame = CGRect(
            x: 0.0, y: 0.0,
            width: Constants.avatarSizeHeight,
            height: Constants.avatarSizeHeight
        )
        imageView.layer.cornerRadius = Constants.avatarSizeHeight / 2
        imageView.clipsToBounds = true
        return UIBarButtonItem(customView: control)
    }
}

