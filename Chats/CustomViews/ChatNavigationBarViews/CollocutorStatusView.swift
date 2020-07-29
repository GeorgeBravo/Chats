//
//  CollocutorStatusView.swift
//  Chats
//
//  Created by Касилов Георгий on 30.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class CollocutorStatusView: ChatNavigationBarView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collocutorImageView.cornerRadius = collocutorImageView.frame.height / 2
    }
    
    //MARK: - Views
    private var collocutorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "roflan")
        return imageView
    }()
}


//MARK: - Setup Views

extension CollocutorStatusView {
    private func setupViews() {
        backgroundColor = UIColor.clear
        containerView = collocutorImageView
        super.setupSubviews()
    }
    
    public func setup(with collocutor: Collocutor) {
        DispatchQueue.main.async {
            self.titleLabelText = collocutor.name
            self.collocutorImageView.image = collocutor.collocutorImage
            
            self.statusLabelTextColor = collocutor.status.labelColor
            self.statusLabelText = collocutor.status.stringDescription
        }
    }
}
