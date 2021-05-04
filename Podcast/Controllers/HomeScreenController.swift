//
//  HomeScreenController.swift
//  Podcast
//
//  Created by Mo on 2021-04-30.
//

import UIKit
import AVKit

class HomeScreenController: UIViewController {
    
    let cellIdentifier = "cell"
    @IBOutlet weak var categoryContainerView: UIView!
    
//    var podcasts = [Podcast]()
    var playerView: HomePagePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomePlayerView()
        
        let categoryView = HomeCategorySectionView(category: .comedy)
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryContainerView.addSubview(categoryView)
        
        categoryView.topAnchor.constraint(equalTo: categoryContainerView.topAnchor).isActive = true
        categoryView.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor).isActive = true
        categoryView.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor).isActive = true
        categoryView.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor).isActive = true
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView.currentEpisode = UserDefaults.standard.fetchCurrentEpisode() 
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    fileprivate func configureHomePlayerView() {
        playerView = HomePagePlayerView.initFromNib()
        playerContainerView.addSubview(playerView)
        playerView.topAnchor.constraint(equalTo: playerContainerView.topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: playerContainerView.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: playerContainerView.trailingAnchor).isActive = true
        playerView.layer.cornerRadius = 16
        //        playerView.layer.borderColor = UIColor.gray.cgColor
        //        playerView.layer.borderWidth = 2
        //        playerView.layer.applySketchShadow(spread: 1.0)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.layoutIfNeeded()
        
        playerView.addTarget(self, action: #selector(didTapHomePlayerView), for: .touchUpInside)
    }
    
    @objc private func didTapHomePlayerView() {
        guard let audioPlayer = UIApplication.mainTabBarController()?.audioPlayerView else {return}
        if audioPlayer.episode == nil {
            audioPlayer.persistedProgress = UserDefaults.standard.cmtime(forKey: UserDefaults.currentTimeKey)
            audioPlayer.episode = playerView.currentEpisode
        }
        audioPlayer.handleTapMaximize()
    }
    
    @IBOutlet weak var playerContainerView: UIControl!
}
