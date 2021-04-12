//
//  AudioPlayerView+Gestures.swift
//  Podcast
//
//  Created by Mo on 2021-04-10.
//

import UIKit


extension AudioPlayerView {
    internal func setupGestures() {
        miniPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        miniPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanMaximize)))
        maximizedStackedView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanMinimize)))
    }
    
    fileprivate func handlePanChanged(_ translation: CGPoint) {
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        maximizedStackedView.alpha = -translation.y/200
        miniPlayerView.alpha = 1 + translation.y/200
    }
    
    fileprivate func handlePanEnded(_ translation: CGPoint, _ velocity: CGPoint) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.transform = .identity
            if -translation.y > 200 || velocity.y > 50 {
                UIApplication.mainTabBarController()?.maximizePlayer()
            } else {
                self.maximizedStackedView.alpha = 0
                self.miniPlayerView.alpha = 1
            }
        }
    }
    
    @objc func handlePanMinimize(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: superview)
        if gesture.state == .changed {
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
        else if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
                self.transform = .identity
                if translation.y > 200 {
                    UIApplication.mainTabBarController()?.minimizePlayer()
                }
            }
        }
    }
    
    @objc func handlePanMaximize(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: superview)
        let velocity = gesture.velocity(in: superview)
        if gesture.state == .changed {
            handlePanChanged(translation)
        }
        else if gesture.state == .ended {
            handlePanEnded(translation, velocity)
        }
    }
    
    @objc func handleTapMaximize() {
        UIApplication.mainTabBarController()?.maximizePlayer()
    }
}
