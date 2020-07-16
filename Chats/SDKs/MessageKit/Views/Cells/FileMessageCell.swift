//
//  FileMessageCell.swift
//  Chats
//
//  Created by Mykhailo H on 7/14/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

final class FileMessageCell: MessageContentCell, TableViewCellSetup {
    
    //MARK: Lifecycle
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        heightConstraint?.constant = 200
        super.prepareForReuse()
    }
    
    // MARK: - Views
    
    private lazy var fileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var fileNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var fileSizeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: ColorName.coolGrey)
        return label
    }()
    
    private var heightConstraint: NSLayoutConstraint?
    
    // MARK: - Setup
    
    override func setup(with viewModel: TableViewCellModel) {
        super.setup(with: viewModel)
        guard let model = viewModel as? ChatTableViewFileCellModel else { return }
        
        if model.file.image.size != CGSize(width: 0.0, height: 0.0) {
             fileImageView.image = model.file.image
        } else {
            fileImageView.image = UIImage(named: "documentIcon")
        }
        fileSizeLabel.text = setupSize(data: model.file.data)
        fileNameLabel.text = model.file.fileName
        
        messageContainerView.backgroundColor = model.isIncomingMessage ? UIColor.paleGrey : UIColor.coolGrey
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - Setup Views
extension FileMessageCell {
    private func setupViews() {
        super.setupSubviews()
        selectionStyle = .none
        
        messageContainerView.addSubview(fileImageView) {
            $0.top == messageContainerView.topAnchor + 8
            $0.bottom == messageContainerView.bottomAnchor - 8
            $0.leading == messageContainerView.leadingAnchor + 8
            $0.size([\.all: 50])
        }
        
        messageContainerView.addSubview(fileNameLabel) {
            $0.top == messageContainerView.topAnchor + 10
            $0.leading == fileImageView.trailingAnchor + 10
            $0.trailing == messageContainerView.trailingAnchor - 10
            $0.width >= UIScreen.main.bounds.width * 0.3
            $0.width <= UIScreen.main.bounds.width * 0.6
        }
        
        messageContainerView.addSubview(fileSizeLabel) {
            $0.top == fileNameLabel.bottomAnchor + 1
            $0.leading == fileImageView.trailingAnchor + 10
            $0.trailing == messageContainerView.trailingAnchor - 10
        }
    }
    
    func setupSize(data: Data) -> String{
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useKB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(data.count))
        return string
    }
}

