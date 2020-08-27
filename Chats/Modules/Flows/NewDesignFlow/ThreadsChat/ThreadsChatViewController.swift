// 
//  ThreadsChatViewController.swift
//  Chats
//
//  Created by Mykhailo H on 8/19/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import BRIck

protocol ThreadsChatPresentableListener: class {

    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class ThreadsChatViewController: UIViewController {

    //MARK: - Views
    
    private lazy var mainView = UIView.create {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = UIView.underlayViewCornerRadius()
        $0.clipsToBounds = true
    }
    
    //MARK: - Properties
    weak var listener: ThreadsChatPresentableListener?
    
    var transitionController = ChatTransitionController(duration: 0.6)
    private var lastLocation: CGPoint!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupGesture()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        view.addSubview(mainView) {
            $0.top == view.topAnchor
            $0.bottom == view.bottomAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
    }
    
    //MARK: - Gesture
    private func setupGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        
        let percentX = abs(translate.x) / (view.frame.width / 2)
        let percentY = abs(translate.y) / (view.frame.height / 2)
        let percent = max(percentX, percentY)
        
        switch gesture.state {
        case .began:
            lastLocation = mainView.center
        case .changed:
            let translation = gesture.translation(in: view)
            mainView.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
        case .ended:
            let velocity = gesture.velocity(in: gesture.view)
            if percent > 0.5 || velocity.y > 500 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.mainView.center = self.view.center
                })
            }
        default:
            break
        }
    }
}

extension ThreadsChatViewController: ThreadsChatPresentable {}

extension ThreadsChatViewController: ThreadsChatViewControllable {}

extension ThreadsChatViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        
        return abs(gestureRecognizer.velocity(in: view).x) > abs(gestureRecognizer.velocity(in: view).y)
    }
    
}
