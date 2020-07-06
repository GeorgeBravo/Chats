//
//  UniformKeyPathInitializable+Init.swift
//  Layout
//
//  Created by Artem Orynko on 1/26/19.
//  Copyright © 2019 gorilka-team. All rights reserved.
//

import Foundation
import UIKit

extension UniformKeyPathInitializable {
    public init(dictionaryLiteral elements: (WritableKeyPath<Self, Self.Value>, Self.Value)...) {
        self.init()
        elements.forEach { self[keyPath: $0.0] = $0.1 }
    }
}
