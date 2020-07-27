//
//  CollocutorNavBarSettupable.swift
//  Chats
//
//  Created by Касилов Георгий on 30.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

protocol CollocutorNavBarSettupable: class {
    func setupNavBar(with collocutor: Collocutor, target: Any?, action: Selector?)
    func setupNavBar(with groupInfo: ChatListTableViewCellModel, target: Any?, action: Selector?)
}

extension CollocutorNavBarSettupable where Self: UIViewController  {
    
    func setupNavBar(with groupInfo: ChatListTableViewCellModel, target: Any?, action: Selector?) {
        let groupChatStatusView = GroupChatViewStatusView()
        groupChatStatusView.setup(with: groupInfo)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        groupChatStatusView.addGestureRecognizer(tapGestureRecognizer)
        groupChatStatusView.isUserInteractionEnabled = true
        
        let barButton = UIBarButtonItem(customView: groupChatStatusView)
        
        if navigationItem.leftBarButtonItems == nil {
            navigationItem.leftBarButtonItems = []
        }
    
        navigationItem.leftBarButtonItems?.append(barButton)

        navigationController?.navigationBar.barTintColor = UIColor.white

        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupNavBar(with collocutor: Collocutor, target: Any? = nil, action: Selector? = nil) {
        
        let collocutorView: CollocutorStatusView = CollocutorStatusView()
        collocutorView.setup(with: collocutor)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        collocutorView.addGestureRecognizer(tapGestureRecognizer)
        collocutorView.isUserInteractionEnabled = true
        
        let barButton = UIBarButtonItem(customView: collocutorView)
        
//        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 10, height: (navigationController?.navigationBar.frame.height)!))))
        navigationItem.leftBarButtonItems?.append(barButton)

        navigationController?.navigationBar.barTintColor = UIColor.white

        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
