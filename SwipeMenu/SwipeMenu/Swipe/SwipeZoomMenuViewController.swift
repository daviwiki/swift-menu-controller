//
//  SwipeZoomMenuViewController.swift
//  SwipeMenu
//
//  Created by David Martinez on 27/07/2017.
//  Copyright © 2017 atenea. All rights reserved.
//

import UIKit

protocol SwipeZoomMenuInput {
    
    typealias Completion = () -> ()
    
    func setConfiguration(configuration: SwipeZoomMenuViewController.Configuration)
    func setContentController(vc: UIViewController)
    func setMenuController(vc: UIViewController)
    
    /**
     Open the menu programatically with animation
     */
    func openMenu(completion: Completion?)
    
    /**
     Close the menu with animation
     */
    func closeMenu(completion: Completion?)
    
}

class SwipeZoomMenuViewController: UIViewController {

    struct Configuration {
        
        var animationDuration = TimeInterval(0.4)
        var scaleFactor = CGFloat(0.9)
        var marginRight = CGFloat(64.0)
        
        var shadowOffset = CGSize(width: -8, height: 10)
        var shadowRadius = CGFloat(4.0)
        var shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        var shadowOpacity = Float(1.0)
        
    }
    
    fileprivate enum AnimationType {
        case none
        case open
        case slideOpen
        case close
        case slideClose
    }
    
    fileprivate enum EdgeType {
        case leftEdge
        case rightEdge
    }
    
    // External accesible properties
    fileprivate var configuration = Configuration()
    fileprivate var contentVC: UIViewController?
    fileprivate var menuVC: UIViewController?
    
    // Edge gestures
    fileprivate var leftGesture: UIScreenEdgePanGestureRecognizer?
    fileprivate var rightGesture: UIScreenEdgePanGestureRecognizer?
    
    // Content containers
    fileprivate var contentContainerView: UIView!
    fileprivate var contentContainerBlockView : UIView?
    
    // Animation status
    fileprivate var currentAnimationType = AnimationType.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentContainerView()
        setupLeftEdgeGestureRecognizer()
        setupRightEdgeGestureRecognizer()
    }
    
    private func setupContentContainerView() {
        let frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height)
        
        contentContainerView = UIView(frame: frame)
        contentContainerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentContainerView.autoresizesSubviews = true
        contentContainerView.backgroundColor = UIColor.clear
        contentContainerView.clipsToBounds = false /* to allow shadows */
        contentContainerView.layer.masksToBounds = false /* to allow shadows */
        contentContainerView.layer.shadowOffset = configuration.shadowOffset
        contentContainerView.layer.shadowRadius = configuration.shadowRadius
        contentContainerView.layer.shadowColor = configuration.shadowColor
        contentContainerView.layer.shadowOpacity = configuration.shadowOpacity
        
        view.addSubview(contentContainerView)
    }
    
    private func setupLeftEdgeGestureRecognizer() {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftGesture(_:)))
        gesture.edges = .left
        view.addGestureRecognizer(gesture)
        
        leftGesture = gesture
    }
    
    private func setupRightEdgeGestureRecognizer() {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(rightGesture(_:)))
        gesture.edges = .right
        gesture.isEnabled = false
        view.addGestureRecognizer(gesture)
        
        rightGesture = gesture
    }
}

extension SwipeZoomMenuViewController: SwipeZoomMenuInput {
    
    func setConfiguration(configuration: SwipeZoomMenuViewController.Configuration) {
        self.configuration = configuration
    }
    
    func setContentController(vc: UIViewController) {
        self.contentVC = vc
        
        loadViewIfNeeded()
        
        if let vc = self.contentVC {
            removeController(vc: vc)
        }
        
        addController(vc: vc, into: contentContainerView)
    }
    
    func setMenuController(vc: UIViewController) {
        self.menuVC = vc
        
        loadViewIfNeeded()
        
        if let vc = self.menuVC {
            removeController(vc: vc)
        }
        
        addController(vc: vc, into: view)
        view.sendSubview(toBack: vc.view)
    }
    
    private func removeController(vc: UIViewController) {
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    private func addController(vc: UIViewController, into view: UIView) {
        addChildViewController(vc)
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height)
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    func openMenu(completion: SwipeZoomMenuInput.Completion? = nil) {
        
        guard let transformView = contentContainerView else { return }
        guard currentAnimationType == .none else { return }
        currentAnimationType = .open
        
        let windowWidth = view.frame.width
        let marginRight = configuration.marginRight
        let scaleFactor = configuration.scaleFactor
        let animationDuration = configuration.animationDuration
        
        let maxX = windowWidth - marginRight - ((1 - scaleFactor) * windowWidth) / 2.0
        let tScale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let tTranslation = CGAffineTransform(translationX: maxX, y: 0.0)
        let tResult = tScale.concatenating(tTranslation)
        
        let timing = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: animationDuration, timingParameters: timing)
        
        addContentContainerBlockLayer()
        
        // Transform animations
        animator.addAnimations {
            transformView.transform = tResult
        }
        
        animator.addCompletion { (position) in
            
            self.rightGesture?.isEnabled = true
            self.leftGesture?.isEnabled = false
            self.currentAnimationType = .none
            
            completion?()
        }
        
        animator.startAnimation()
    }
    
    fileprivate func addContentContainerBlockLayer() {
        
        let frame = contentVC?.view.frame ?? CGRect.zero
        let blockView = UIView(frame: frame)
        blockView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentContainerView.addSubview(blockView)
        contentContainerView.bringSubview(toFront: blockView)
        contentContainerBlockView = blockView
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onContentViewBlockClicked(_:)))
        blockView.addGestureRecognizer(gesture)
    }
    
    @objc private func onContentViewBlockClicked(_ sender: Any) {
        closeMenu()
    }
    
    func closeMenu(completion: SwipeZoomMenuInput.Completion? = nil) {
        
        guard let transformView = contentContainerView else { return }
        guard currentAnimationType == .none else { return }
        currentAnimationType = .close
        
        removeContentContainerBlockLayer()
        let animationDuration = configuration.animationDuration
        
        let tResult = CGAffineTransform.identity
        let timing = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: animationDuration, timingParameters: timing)
        
        animator.addAnimations {
            transformView.transform = tResult
        }
        
        animator.addCompletion { (position: UIViewAnimatingPosition) in
            
            self.leftGesture?.isEnabled = true
            self.rightGesture?.isEnabled = false
            self.currentAnimationType = .none
            
            completion?()
        }
        
        animator.startAnimation()
    }
    
    fileprivate func removeContentContainerBlockLayer() {
        contentContainerBlockView?.removeFromSuperview()
        contentContainerBlockView = nil
    }
}

/**
 SwipeZoomMenuViewController extension to store slide properties
 */
extension SwipeZoomMenuViewController {
    
    @nonobjc static var animatorSafePointer: Int32 = 0
    @nonobjc static var acelerationSafePointer: Int32 = 1
    
    fileprivate var animator: UIViewPropertyAnimator? {
        get {
            return objc_getAssociatedObject(self, &SwipeZoomMenuViewController.animatorSafePointer) as? UIViewPropertyAnimator
        }
        set {
            objc_setAssociatedObject(self, &SwipeZoomMenuViewController.animatorSafePointer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate var acceleration: (TimeInterval, CGFloat) {
        get {
            return objc_getAssociatedObject(self, &SwipeZoomMenuViewController.acelerationSafePointer) as? (TimeInterval, CGFloat) ?? (0, 0)
        }
        set {
            objc_setAssociatedObject(self, &SwipeZoomMenuViewController.acelerationSafePointer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

/**
 SwipeZoomMenuViewController extension to manage left gesture recognizers
 */
extension SwipeZoomMenuViewController {

    @objc func leftGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        manageEdgePanGesture(gesture: gesture, type: .slideOpen)
    }
    
}

/**
 SwipeZoomMenuViewController extension to manage right gesture recognizers
 */
extension SwipeZoomMenuViewController {
    
    @objc func rightGesture (_ gesture: UIScreenEdgePanGestureRecognizer) {
        manageEdgePanGesture(gesture: gesture, type: .slideClose)
    }
    
}

/**
 SwipeZoomMenuViewController extension to manage left/right gesture recognizers
 */
extension SwipeZoomMenuViewController {
    
    fileprivate func manageEdgePanGesture(gesture: UIScreenEdgePanGestureRecognizer, type: AnimationType) {
        
        guard let transformView = contentContainerView else { return }
        guard let view = gesture.view else { return }
        guard (currentAnimationType == .none || currentAnimationType == type) else { return }
        currentAnimationType = type
        
        let windowWidth = view.frame.width
        let marginRight = configuration.marginRight
        let scaleFactor = configuration.scaleFactor
        let animationDuration = configuration.animationDuration
        
        let translation = gesture.translation(in: view)
        let maxX = windowWidth - marginRight - ((1 - scaleFactor) * windowWidth) / 2.0
        let percent = abs(translation.x) / windowWidth
        
        switch gesture.state {
        case .began:
            
            // Calculate initial acceleration
            acceleration = (Date.timeIntervalSinceReferenceDate, translation.x)
            
            let timing = UICubicTimingParameters(animationCurve: .easeInOut)
            animator = UIViewPropertyAnimator(duration: animationDuration, timingParameters: timing)
            
            if type == .slideOpen {
                animator?.addAnimations {
                    transformView.transform = self.getOpenTransform(translation: maxX)
                }
            } else if type == .slideClose {
                animator?.addAnimations {
                    transformView.transform = self.getCloseTransform()
                }
            } else {
                animator = nil
                gesture.isEnabled = false
                gesture.isEnabled = true
                return
            }
            
            animator?.addCompletion({ (_) in
                self.currentAnimationType = .none
            })
            animator?.stopAnimation(false)
            break
            
        case .changed:
            animator?.fractionComplete = percent
            break
        case .ended, .cancelled:
            
            leftGesture?.isEnabled = false
            rightGesture?.isEnabled = false
            
            var mustReverse = percent < 0.6
            
            let now = Date.timeIntervalSinceReferenceDate
            let currentX = translation.x
            
            if (now - acceleration.0 < 0.2 && abs(currentX - acceleration.1) > 70) {
                mustReverse = false
            }
            
            animator?.isReversed = mustReverse
            
            animator?.addCompletion({ (_) in
                self.reactivateGestures(for: type, reversed: mustReverse)
            })
            
            if mustReverse == false {
                manageAdditionalLayers(for: type)
            }
            
            animator?.startAnimation()
            
            break
        default:
            break
        }
        
    }
    
    private func manageAdditionalLayers (`for` type: AnimationType) {
        if type == .slideOpen {
            addContentContainerBlockLayer()
        } else {
            removeContentContainerBlockLayer()
        }
    }
    
    private func reactivateGestures(`for` type: AnimationType, reversed: Bool) {
        if type == .slideOpen {
            leftGesture?.isEnabled = reversed
            rightGesture?.isEnabled = !reversed
        } else if type == .slideClose {
            leftGesture?.isEnabled = !reversed
            rightGesture?.isEnabled = reversed
        }
    }
    
    private func getOpenTransform(translation x: CGFloat) -> CGAffineTransform {
        let scaleFactor = configuration.scaleFactor
        let tScale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let tTranslation = CGAffineTransform(translationX: x, y: 0.0)
        let tResult = tScale.concatenating(tTranslation)
        return tResult
    }
    
    private func getCloseTransform() -> CGAffineTransform {
        return CGAffineTransform.identity
    }
}
