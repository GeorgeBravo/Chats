//
//  UnderneathView.swift
//  Chats
//
//  Created by Касилов Георгий on 09.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

final class UnderneathView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var borderView = UIView
        .create {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
}

// MARK: Setup Views
extension UnderneathView {
    private func setupViews() {
        backgroundColor = UIColor.white
        addSubview(borderView) {
            $0.bottom == bottomAnchor
            $0.leading == leadingAnchor
            $0.trailing == trailingAnchor
            $0.height == 0.3
        }
    }
}
