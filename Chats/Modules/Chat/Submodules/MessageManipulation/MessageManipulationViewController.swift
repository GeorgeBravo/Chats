// 
//  MessageManipulationViewController.swift
//  Chats
//
//  Created by user on 20.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import BRIck

private struct Constants {
    static let estimatedCellHeigth: CGFloat = 100.0
}

protocol MessageManipulationPresentableListener: class {

    func hideMessageManipulation()
    func numberOfRows() -> Int
    func cellModelForRow(at indexPath: IndexPath) -> TableViewCellModel
    func cellOffsetFrame() -> FrameValues
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class MessageManipulationViewController: UIViewController {

    // MARK: - Variables
    weak var listener: MessageManipulationPresentableListener?
    
    // MARK: - UI Variables
    private var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()
    
    private lazy var messageManipulationTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = Constants.estimatedCellHeigth
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView()
        tableView.register(TextMessageCell.self)
        tableView.register(MessageContentCell.self)
        tableView.register(LocationMessageCell.self)
        tableView.register(ChatSectionHeaderView.self)
        tableView.register(MediaMessageCell.self)
        tableView.register(FileMessageCell.self)
        tableView.register(ContactMessageCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestureRecognizers()
    }
}

extension MessageManipulationViewController: MessageManipulationPresentable {
    
    func update() {
        messageManipulationTableView.reloadData()
    }
    
}

extension MessageManipulationViewController: MessageManipulationViewControllable {}

extension MessageManipulationViewController {
    
    func setupViews() {
        view.backgroundColor = .lightGray
        
        view.addSubview(blurView) {
            $0.top == view.topAnchor
            $0.bottom == view.bottomAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
        
        if let cellOffsetFrame = listener?.cellOffsetFrame() {
            messageManipulationTableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: cellOffsetFrame.widthValue, height: cellOffsetFrame.yPositionValue))
        }
        
        view.addSubview(messageManipulationTableView) {
            $0.top == view.topAnchor
            $0.bottom == view.bottomAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
        messageManipulationTableView.addGestureRecognizer(tapGestureRecognizer)
    }

}

// MARK: - Selectors
extension MessageManipulationViewController {
    @objc func blurViewTapped() {
        listener?.hideMessageManipulation()
    }
}

extension MessageManipulationViewController: UITableViewDelegate {}

extension MessageManipulationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = listener?.numberOfRows() else { return 0 }
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = listener?.cellModelForRow(at: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(of: cellModel.cellType.classType)
        if let cell = cell as? TableViewCellSetup {
            cell.setup(with: cellModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : UITableView.automaticDimension
    }
    
}

extension MessageManipulationViewController: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .fullScreen
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .fullScreen
    }
}
