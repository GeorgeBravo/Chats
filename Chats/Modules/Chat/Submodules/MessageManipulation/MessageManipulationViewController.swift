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
    static let tableViewBootomInset: CGFloat = 20.0
}

protocol MessageManipulationPresentableListener: class {

    func hideMessageManipulation()
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func cellModelForRow(at indexPath: IndexPath) -> TableViewCellModel
    func sectionModel(for section: Int) -> TableViewSectionModel
    func cellOffsetFrame() -> FrameValues
    func addOptions()
    func lastItemIndexPath() -> IndexPath
    func firstItemIndexPath() -> IndexPath?
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class MessageManipulationViewController: UIViewController {

    // MARK: - Variables
    weak var listener: MessageManipulationPresentableListener?
    
    // MARK: - UI Variables
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0.5
        return blurView
    }()
    
    private lazy var messageManipulationTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = Constants.estimatedCellHeigth
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.tintColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.register(TextMessageCell.self)
        tableView.register(MessageContentCell.self)
        tableView.register(LocationMessageCell.self)
        tableView.register(ChatSectionHeaderView.self)
        tableView.register(MediaMessageCell.self)
        tableView.register(FileMessageCell.self)
        tableView.register(ContactMessageCell.self)
        tableView.register(MessageManipulationTableViewCell.self)
        tableView.register(MessageManipulationSectionHeaderView.self)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.addOptions()
    }
}

extension MessageManipulationViewController: MessageManipulationPresentable {
    
    func update() {
        DispatchQueue.main.async { [weak self] in
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self?.checkOffsets()
            }
            self?.messageManipulationTableView.reloadData()
            CATransaction.commit()
        }
    }
    
}

extension MessageManipulationViewController: MessageManipulationViewControllable {}

extension MessageManipulationViewController {
    
    func setupViews() {
        view.isOpaque = false
        view.backgroundColor = .clear
        view.tintColor = .clear
        
        view.addSubview(blurView) {
            $0.top == view.topAnchor
            $0.bottom == view.bottomAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
        
        var safeAreaTopInset: CGFloat = 0.0
        if let cellOffsetFrame = listener?.cellOffsetFrame() {
            if cellOffsetFrame.yPositionValue < 0 {
                safeAreaTopInset = cellOffsetFrame.yPositionValue
            } else {
                messageManipulationTableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: cellOffsetFrame.widthValue, height: cellOffsetFrame.yPositionValue))
            }
        }
        
        var safeAreaBottomInset: CGFloat = 0.0
        if let insets = UIApplication.shared.keyWindow?.safeAreaInsets {
            safeAreaBottomInset = insets.bottom + Constants.tableViewBootomInset
        }
        messageManipulationTableView.contentInset = UIEdgeInsets(top: safeAreaTopInset, left: 0.0, bottom: safeAreaBottomInset, right: 0.0)
        
        view.addSubview(messageManipulationTableView) {
            $0.top == view.topAnchor
            $0.bottom == view.bottomAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        messageManipulationTableView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Animation logic
    func checkOffsets() {
        guard let lastCellIndexPath = listener?.lastItemIndexPath() else { return }
        guard let lastCell = messageManipulationTableView.cellForRow(at: lastCellIndexPath) else {
            scrollToCell(at: lastCellIndexPath)
            return
        }
        if messageManipulationTableView.contentSize.height > view.safeAreaLayoutGuide.layoutFrame.height {
            scrollToCell(at: lastCellIndexPath)
            return
        }
        
        if lastCell.frame.maxY > view.safeAreaLayoutGuide.layoutFrame.maxY {
            scrollToCell(at: lastCellIndexPath)
            return
        }
        
        guard let firstCellIndexPath = listener?.firstItemIndexPath(),
            let firstCell = messageManipulationTableView.cellForRow(at: firstCellIndexPath),
            let firstCellRect = firstCell.superview?.convert(firstCell.frame, to: nil) else { return }
        if firstCellRect.minY < view.safeAreaLayoutGuide.layoutFrame.minY && lastCell.frame.maxY < view.safeAreaLayoutGuide.layoutFrame.maxY {
            
            var safeAreaTopInset: CGFloat = 0.0
            if let insets = UIApplication.shared.keyWindow?.safeAreaInsets {
                safeAreaTopInset = insets.top + Constants.tableViewBootomInset
            }
            
            CATransaction.begin()
            messageManipulationTableView.setContentOffset(CGPoint(x: 0.0, y: -safeAreaTopInset), animated: true)
            CATransaction.commit()
        }
    }
    
    func scrollToCell(at indexPath: IndexPath, position: UITableView.ScrollPosition = .bottom) {
        CATransaction.begin()
        messageManipulationTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        CATransaction.commit()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listener?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = listener?.numberOfRows(in: section) else { return 0 }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else { return nil }
        guard let sectionModel = listener?.sectionModel(for: section),
            let classType = sectionModel.headerViewType.classType else { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(of: classType)
        if let view = view as? SectionHeaderViewSetup {
            view.setup(with: sectionModel)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !cell.isKind(of: MessageContentCell.self) else { return }
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            animations: {
                cell.alpha = 1
        })

    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.alpha = 0

        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            animations: {
                view.alpha = 1
        })
    }
}
