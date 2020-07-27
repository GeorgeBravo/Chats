//
//  UITableView+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import UIKit

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        let identifier = cellClass.reusableIdentifier
        register(cellClass, forCellReuseIdentifier: identifier)
    }

    func register(_ headerFooterClass: UITableViewHeaderFooterView.Type) {
        let identifier = headerFooterClass.reusableIdentifier
        register(headerFooterClass, forHeaderFooterViewReuseIdentifier: identifier)
    }

    func register(cellType type: UITableViewCell.Type) {
        register(type.nib, forCellReuseIdentifier: type.reusableIdentifier)
    }

    func register(cellTypes types: UITableViewCell.Type...) {
        types.forEach(register(cellType:))
    }

    func register(cellTypes types: [UITableViewCell.Type]) {
        types.forEach(register(cellType:))
    }

    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        let identifier = Cell.reusableIdentifier
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("\(Cell.self) should be a \(UITableViewCell.self)")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(of type: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: type.self)) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(of type: T.Type) -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: String(describing: type.self)) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return headerFooterView
    }

    func dequeueReusableHeaderFooterView<HeaderFooter: UITableViewHeaderFooterView>() -> HeaderFooter {
        let identifier = HeaderFooter.reusableIdentifier
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? HeaderFooter else {
            fatalError("\(HeaderFooter.self) should be a \(UITableViewHeaderFooterView.self)")
        }
        return headerFooter
    }
}

extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
            { _ in completion() }
    }
}
