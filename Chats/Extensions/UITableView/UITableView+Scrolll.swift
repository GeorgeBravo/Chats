//
//  UITableView+Scrolll.swift
//  Chats
//
//  Created by Касилов Георгий on 09.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    public func scrollToLastItem(at pos: UITableView.ScrollPosition = .bottom, animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        
        let lastSection = numberOfSections - 1
        let lastItemIndex = numberOfRows(inSection: lastSection) - 1
        
        guard lastItemIndex >= 0 else { return }
        
        let indexPath = IndexPath(row: lastItemIndex, section: lastSection)
        scrollToRow(at: indexPath, at: pos, animated: animated)
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func hasRowAtIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
