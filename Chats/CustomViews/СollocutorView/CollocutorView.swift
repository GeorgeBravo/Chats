//
//  CollocutorView.swift
//  Chats
//
//  Created by Касилов Георгий on 30.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class CollocutorView: UIView {

    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func onGradientViewDidTap(_ action: @escaping GradientCircleView.GradientCircleViewActionHandler) {
//        gradientView.addAction(action)
//    }
    
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
//        view.margin = 10
        view.isCustomViewRounded = true
        view.customView = collocutorImageView
        
        return view
    }()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.darkText
        label.numberOfLines = 1

        return label
    }()

    fileprivate lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1

        return label
    }()

    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, statusLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 2

        return stackView
    }()
}


//MARK: - Setup Views

extension CollocutorView {
    private func setupViews() {
        backgroundColor = UIColor.clear 
        
        addSubview(gradientView) {
            $0.leading == leadingAnchor
            $0.top == topAnchor
            $0.bottom == bottomAnchor
            $0.height == 44
            $0.width == gradientView.heightAnchor
        }

        addSubview(stackView) {
            $0.leading == gradientView.trailingAnchor + 8
            $0.top == topAnchor
            $0.bottom == bottomAnchor
            $0.trailing == trailingAnchor
        }
    }
    
    public func setup(with collocutor: Collocutor) {
        DispatchQueue.main.async {
            self.titleLabel.text = collocutor.name
            self.collocutorImageView.image = collocutor.collocutorImage

            switch collocutor.status {
            case .online:
                self.statusLabel.textColor = UIColor(named: .electricBlue)
                self.statusLabel.text = "Online"
            case .offline:
                self.statusLabel.textColor = UIColor.lightGray
                self.statusLabel.text = "Offline"
            }
             
        }
    }
}
