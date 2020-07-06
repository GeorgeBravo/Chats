//
//  ActiveSetupableCell.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

protocol ActiveSetupableCell: SetupableCell {
    associatedtype Handler
    var actionHandler: ((Handler) -> Void)? { get set }
    func setup(with model: Model, actionHandler: @escaping (Handler) -> Void)
}

extension ActiveSetupableCell {
    func setup(with model: Model, actionHandler: @escaping (Handler) -> Void) {
        self.actionHandler = actionHandler

        setup(with: model)
    }
}
