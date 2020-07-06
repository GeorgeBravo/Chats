//
//  ViewControllable+ShowError.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import BRIck
import UIKit

extension Presentable where Self: ViewControllable {
    public func showError(withText text: String, title: String? = nil) {
        let okAction = "ОК".alertAction()
        let alertController = UIAlertController.Style.alert.controller(title: title, message: text, actions: [okAction])

        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}
