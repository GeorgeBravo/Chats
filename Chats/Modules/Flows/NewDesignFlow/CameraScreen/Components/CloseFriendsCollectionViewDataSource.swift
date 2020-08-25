//
//  CloseFriendsCollectionViewDataSource.swift
//  Chats
//
//  Created by user on 21.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let minimumInteritemSpacing: CGFloat = 0.0
    static let minimumIPhoneLineSpacing: CGFloat = 4.0
    static let minimumIPadLineSpacing: CGFloat = 29.0
    static let iPhoneSideCellOffset: CGFloat = 4.0
    static let iPadSideCellOffset: CGFloat = 86.0
}

protocol CloseFriendsCollectionViewDataSourceDelegate: class {
    func updateCloseFriendsCollectionView()
}

class CloseFriendsCollectionViewDataSource: NSObject {
    
    // MARK: - Variables
    weak var delegate: CloseFriendsCollectionViewDataSourceDelegate?
    private var models = [CloseFriendCollectionViewCellModel]()
    var minimumInteritemSpacing: CGFloat = 0.0
    let minimumLineSpacing: CGFloat = 0.0
    var sideCellOffset: CGFloat = 0.0
    private var userButtonWidth: CGFloat = 0.0
    
    // MARK: - Logic
    func fillModels(with models: [CloseFriendCollectionViewCellModel]) {
        self.models = models
        self.models.append(models)
        self.models.append(models[1])
        delegate?.updateCloseFriendsCollectionView()
    }
}

// MARK: - UICollectionViewDelegate
extension CloseFriendsCollectionViewDataSource: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource
extension CloseFriendsCollectionViewDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = models[indexPath.item]
        cellModel.buttonWidth = userButtonWidth
        guard let cell = collectionView.dequeueReusableCell(of: cellModel.cellType.classType, for: indexPath) as? CloseFriendCollectionViewCell else {
            return UICollectionViewCell()
        }
//        cell.delegate = self
        cell.setup(with: cellModel)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CloseFriendsCollectionViewDataSource: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var inset: CGFloat = minimumInteritemSpacing
        var itemsToCount = models.count
        if itemsToCount >= 5 { itemsToCount = 4 }
        let cellWidth = userButtonWidth + sideCellOffset * 2
        let totalCellsWidth = cellWidth * CGFloat(itemsToCount)
        let totalContentSize = totalCellsWidth + minimumInteritemSpacing * CGFloat(itemsToCount - 1)
        inset = (collectionView.bounds.width - totalContentSize) / 2

        return UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let partedWidth = collectionView.bounds.width / 17
        minimumInteritemSpacing = partedWidth
        userButtonWidth = partedWidth * 3
        let width = partedWidth * 3
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
        
}

