//
//  UICollectionViewCell+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//
import UIKit

extension UICollectionViewCell {
    static var reusableIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: self.reusableIdentifier, bundle: nil)
    }
}
