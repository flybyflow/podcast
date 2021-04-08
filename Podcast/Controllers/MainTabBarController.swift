//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Mo on 2021-01-31.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        tabBar.tintColor = .purple
        super.viewDidLoad()
        setupPlayerDetailsView()
        
        viewControllers = [generateControllers(name: "Search", with: SearchNavController()),
                           generateControllers(name: "Favorites", with: UIViewController()),
                           generateControllers(name: "Downloads", with: DownloadsController())]
    }
    
    let audioPlayerView = AudioPlayerView.initFromNib()
     
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var mimizedTopAnchorConstraint: NSLayoutConstraint!
    
    private func setupPlayerDetailsView() {
        
         view.insertSubview(audioPlayerView, belowSubview: tabBar)
        
        audioPlayerView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = audioPlayerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        mimizedTopAnchorConstraint = audioPlayerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
//        mimizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.isActive = true
        
        audioPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        audioPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        audioPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func minimizePlayer() {
        self.mimizedTopAnchorConstraint.isActive = true
        self.maximizedTopAnchorConstraint.isActive = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.audioPlayerView.maximizedStackedView.alpha = 0
            self.audioPlayerView.miniPlayerView.alpha = 1
        }
    }
    @objc func maximizePlayer() {
        self.maximizedTopAnchorConstraint.isActive = true
        self.maximizedTopAnchorConstraint.constant = 0
        self.mimizedTopAnchorConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.frame.origin.y = self.view.frame.size.height
            self.audioPlayerView.maximizedStackedView.alpha = 1
            self.audioPlayerView.miniPlayerView.alpha = 0
        }
    }
    
    // MARK: - Helper Methods
    private func generateControllers(name: String,
                                               with rootViewController: UIViewController) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = name
        navController.tabBarItem.image = UIImage(named: name)
        navController.navigationItem.title = name
        
        return navController
    }
    
}


