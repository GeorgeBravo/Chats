//
//  NavigationControllerAnimator.swift
//  Chats
//
//  Created by Eugene Zatserklyaniy on 25.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit


protocol ChatAnimatorDelegate: class {
    func frame(for animator: ChatAnimator) -> CGRect?
    func snapshot(for animator: ChatAnimator) -> UIView?
    func image(for animator: ChatAnimator) -> UIImage?
    func imageFrame(for animator: ChatAnimator) -> CGRect?
    func name(for animator: ChatAnimator) -> String?
    func nameLabelFrame(for animator: ChatAnimator) -> CGRect?
    
    func animationDidStart(for imageAnimator: ChatAnimator)
    func animationDidEnd(for imageAnimator: ChatAnimator)
}

class ChatAnimator: NSObject {
    
    weak var fromDelegate: ChatAnimatorDelegate?
    weak var toDelegate: ChatAnimatorDelegate?
    
    var dimmedView = UIImageView(frame: UIScreen.main.bounds)
    let duration: TimeInterval
    var isPresenting: Bool = true
    
    private let window = UIApplication.shared.windows.first { $0.isKeyWindow }
    private var topInset: CGFloat {
        window?.safeAreaInsets.top ?? 0
    }
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func animatePresenting(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let destinationController = transitionContext.viewController(forKey: .to),
            let snapshotFrame = fromDelegate?.frame(for: self),
            let snapshot = fromDelegate?.snapshot(for: self),
            let image = fromDelegate?.image(for: self),
            let imageFrame = fromDelegate?.imageFrame(for: self),
            let name = fromDelegate?.name(for: self),
            let nameLabelFrame = fromDelegate?.nameLabelFrame(for: self)
        else {
            print("animatePresenting guard")
            
            transitionContext.completeTransition(true)
            transitionContext.viewController(forKey: .to)?.dismiss(animated: false, completion: {
                self.toDelegate?.animationDidEnd(for: self)
            })
            return
        }
        
        let containerView = transitionContext.containerView
        
        //MARK: - Dimmed View
        dimmedView.backgroundColor = .darkGray
        dimmedView.alpha = 0.0
        containerView.addSubview(dimmedView)

        //MARK: - Main View
        let mainView = UIView()
        mainView.backgroundColor = .white
        mainView.frame = CGRect(x: snapshotFrame.minX, y: snapshotFrame.maxY, width: snapshotFrame.width, height: 0)
        mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerView.addSubview(mainView)

        //MARK: - Nav Bar & Snapshot
        let navBarSuperview = UIView()
        navBarSuperview.backgroundColor = .white
        navBarSuperview.frame = snapshotFrame
        navBarSuperview.layer.shadowColor = UIColor.lightGray.cgColor
        navBarSuperview.layer.shadowOffset = CGSize(width: 0, height: 3)
        navBarSuperview.layer.shadowRadius = 3
        navBarSuperview.layer.shadowOpacity = 0.1
        navBarSuperview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.addSubview(navBarSuperview)
        
        snapshot.frame = snapshotFrame
        containerView.addSubview(snapshot)
                
        let navBar = UIView()
        navBar.backgroundColor = .white
        navBar.frame = snapshotFrame
        containerView.addSubview(navBar)
        
        //MARK: - Avatar & name
        let avatarImageView = UIImageView()
        avatarImageView.image = image
        avatarImageView.frame = imageFrame
        avatarImageView.layer.cornerRadius = imageFrame.height / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        navBar.addSubview(avatarImageView)
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.helveticaNeueFontOfSize(size: 16.7, style: .medium)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor(named: ColorName.optionsBlackColor)
        
        nameLabel.frame = nameLabelFrame
        navBar.addSubview(nameLabel)
        
        containerView.bringSubviewToFront(snapshot)
        
        //temp
        let removeFromSuperview = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                snapshot.removeFromSuperview()
                mainView.removeFromSuperview()
                avatarImageView.removeFromSuperview()
                nameLabel.removeFromSuperview()
                navBarSuperview.removeFromSuperview()
                navBar.removeFromSuperview()
                self.dimmedView.removeFromSuperview()
                
                containerView.addSubview(destinationController.view)
            }
        }
        
        fromDelegate?.animationDidStart(for: self)
        
        //MARK: - Animation
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) {
                snapshot.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1) {
                snapshot.transform = .identity
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8) {
                self.dimmedView.alpha = 1
                snapshot.alpha = 0
                navBar.alpha = 1
                navBar.frame.origin.y = self.topInset
                snapshot.frame.origin.y = self.topInset
                navBarSuperview.frame = CGRect(x: snapshotFrame.minX, y: 0, width: snapshotFrame.width, height: snapshotFrame.height + self.topInset)
                mainView.frame = CGRect(x: snapshotFrame.minX, y: navBarSuperview.frame.maxY, width: snapshotFrame.width, height: containerView.frame.height - navBarSuperview.frame.height)
                
                navBarSuperview.layer.cornerRadius = UIView.underlayViewCornerRadius()
                mainView.layer.cornerRadius = UIView.underlayViewCornerRadius()
            }
            
        }, completion: { (finished) in
            navBarSuperview.layer.cornerRadius = 0
            mainView.layer.cornerRadius = 0
            removeFromSuperview()
            
            transitionContext.completeTransition(true)
            self.fromDelegate?.animationDidEnd(for: self)
            self.toDelegate?.animationDidEnd(for: self)
        })
    }
    
    func animateDismissing(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(true)
    }
}

extension ChatAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresenting(using: transitionContext)
        } else {
            animateDismissing(using: transitionContext)
        }
    }
}

