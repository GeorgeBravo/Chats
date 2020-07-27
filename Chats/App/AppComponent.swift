//
//  AppComponent.swift
//  Defender Mobile
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2019 RestySpp. All rights reserved.
//

import BRIck
import UIKit

protocol ApplicationComponent: class {}

class AppComponent: Component<EmptyDependency>, RootDependency, ApplicationComponent {
    @discardableResult
    init(_ completion: @escaping (AppComponent) -> Void) {
        super.init(dependency: EmptyComponent())

        completion(self)
    }

    // MARK: - RootDependency
}
