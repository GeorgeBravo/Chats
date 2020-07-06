//
//  SetupableCell.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

protocol SetupableCell: class {
    associatedtype Model
    func setup(with model: Model)
}

extension SetupableCell {
    func setup(with model: Model) {}
}
