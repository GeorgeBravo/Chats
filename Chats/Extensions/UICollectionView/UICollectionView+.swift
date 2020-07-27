//
//  UICollectionView+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: UICollectionViewCell.Type) {
        let identifier = cellClass.reusableIdentifier
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    func register(cellType type: UICollectionViewCell.Type) {
        self.register(type.nib, forCellWithReuseIdentifier: type.reusableIdentifier)
    }

    func register(cellTypes types: UICollectionViewCell.Type...) {
        types.forEach(register(cellType:))
    }

    func register(cellTypes types: [UICollectionViewCell.Type]) {
        types.forEach(register(cellType:))
    }

    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        let identifier = Cell.reusableIdentifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("\(Cell.self) should be a \(UITableViewCell.self)")
        }

        return cell
    }
}
