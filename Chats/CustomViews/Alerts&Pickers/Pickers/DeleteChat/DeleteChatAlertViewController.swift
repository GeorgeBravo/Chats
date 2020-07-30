//
//  DeleteChatAlertViewController.swift
//  Chats
//
//  Created by Mykhailo H on 7/29/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    func addDeleteChatViewController(interlocutor: String?,isGroup: Bool?, completion: @escaping DeleteChatAlertViewController.Selection) {
        let selection: DeleteChatAlertViewController.Selection = completion
        let vc = DeleteChatAlertViewController(selection: selection, interlocutor: interlocutor, isGroup: isGroup)
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.preferredContentSize.height = vc.preferredSize.height * 0.2
            vc.preferredContentSize.width = vc.preferredSize.width * 0.9
        } else {
            vc.preferredContentSize.height = 116
        }
        set(vc: vc)
    }
}

enum DeleteChatAction: Int {
    case deleteForYourselfAndInterlocutor = 0
    case deleteForYourself = 1
    case clearHistory
}

final class DeleteChatAlertViewController: UIViewController {
    
    public typealias Selection = (DeleteChatAction) -> ()
    
    fileprivate var selection: Selection?
    fileprivate var interlocutorName: String?
    fileprivate var isGroup: Bool = false
    
    var preferredSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    var preferredHeight: CGFloat {
        return 130
    }
    
    fileprivate lazy var headerView: DeleteChatHeaderView = { [unowned self] in
        $0.isGroupChat = self.isGroup
        $0.interlocutoreName = self.interlocutorName
        return $0
        }(DeleteChatHeaderView(frame: .zero))
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = 58
        $0.separatorColor = UIColor.lightGray.withAlphaComponent(0.4)
        $0.separatorInset = .zero
        $0.backgroundColor = nil
        $0.bounces = false
        $0.tableHeaderView = headerView
        $0.tableHeaderView?.height = preferredHeight
        $0.register(LikeButtonCell.self, forCellReuseIdentifier: LikeButtonCell.identifier)
        
        return $0
        }(UITableView(frame: .zero, style: .plain))
    
    
    required init(selection: Selection?, interlocutor: String?, isGroup: Bool?) {
        self.selection = selection
        self.interlocutorName = interlocutor
        self.isGroup = isGroup ?? false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize.height = preferredHeight + (CGFloat(2) * 58)
    }
}

extension DeleteChatAlertViewController: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeButtonCell.identifier) as! LikeButtonCell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        
        if indexPath.row == 0 {
            if !isGroup {
                cell.textLabel?.text = String(format: LocalizationKeys.deleteForMeAnd.localized(), interlocutorName ?? "interlocutor")
            } else {
                cell.textLabel?.text = LocalizationKeys.clearHistory.localized()
            }
        }
        if indexPath.row == 1 {
            if !isGroup {
                cell.textLabel?.text = LocalizationKeys.deleteJustForMe.localized()
            } else {
                cell.textLabel?.text = LocalizationKeys.delete.localized()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if !isGroup {
                selection?(DeleteChatAction.deleteForYourselfAndInterlocutor)
            } else {
                selection?(DeleteChatAction.clearHistory)
            }
        }
        if indexPath.row == 1 {
            selection?(DeleteChatAction.deleteForYourself)
        }
    }
}
