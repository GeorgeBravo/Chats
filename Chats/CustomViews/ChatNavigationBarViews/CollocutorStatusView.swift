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
    
    //MARK: - Views
    
    private var collocutorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "roflan")
        return imageView
    }()
    
    private lazy var gradientView: GradientCircleView = {
        let view = GradientCircleView()
        view.colors = [UIColor(named: .sunflowerYellowTwo).cgColor,
                       UIColor(named: .violetPink).cgColor,
                       UIColor(named: .brightCyan).cgColor]
        view.isCustomViewRounded = true
        view.customView = collocutorImageView
        
        return view
    }()
}


//MARK: - Setup Views

extension CollocutorStatusView {
    private func setupViews() {
        backgroundColor = UIColor.clear
        containerView = gradientView
        super.setupSubviews()
    }
    
    public func setup(with collocutor: Collocutor) {
        DispatchQueue.main.async {
            self.titleLabelText = collocutor.name
            self.collocutorImageView.image = collocutor.collocutorImage
            
            switch collocutor.status {
            case .online:
                self.statusLabelTextColor = UIColor(named: .electricBlue)
                self.statusLabelText = "Online"
            case .offline:
                self.statusLabelTextColor = UIColor.lightGray
                self.statusLabelText = "Offline"
            }
        }
    }
}
