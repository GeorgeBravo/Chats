//
//  CollocutorNavBarSettupable.swift
//  Chats
//
//  Created by Касилов Георгий on 30.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

protocol CollocutorNavBarSettupable: class {
    var collocutorView: CollocutorView { get }
    
    func setupNavBar(with collocutor: Collocutor, target: Any?, action: Selector?)
}

extension CollocutorNavBarSettupable where Self: UIViewController  {
    func setupNavBar(with collocutor: Collocutor, target: Any? = nil, action: Selector? = nil) {
        
        collocutorView.setup(with: collocutor)
        
        let barButton = UIBarButtonItem(customView: collocutorView)
        
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 10, height: (navigationController?.navigationBar.frame.height)!))))
        navigationItem.leftBarButtonItems?.append(barButton)
        
//        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white

        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
