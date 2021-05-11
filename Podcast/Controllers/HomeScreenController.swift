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
    let categoryHeigth: CGFloat = 240
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        self.view.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        v.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        v.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        v.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        return v
        }()
    
    lazy var playerView: HomePagePlayerView = {
        let playerView = HomePagePlayerView.initFromNib()
        playerView.layer.cornerRadius = 16
        playerView.layer.applySketchShadow()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.clipsToBounds = true
        playerView.addTarget(self, action: #selector(didTapHomePlayerView), for: .touchUpInside)
        return playerView
    }()
    
    lazy var currentlyListeningLabel: UILabel = {
        let label = UILabel()
        label.text = "Currently Listening"
        label.font = label.font.withSize(24)
        
        return label
    }()
    
    fileprivate func configureCurrentlyListeningLabel() {
        guard playerView.currentEpisode != nil else {return}
        
        self.scrollView.addSubview(currentlyListeningLabel)
        currentlyListeningLabel.translatesAutoresizingMaskIntoConstraints = false
        currentlyListeningLabel.bottomAnchor.constraint(equalTo: playerView.topAnchor, constant: -8).isActive = true
        currentlyListeningLabel.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 0).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.currentEpisode = UserDefaults.standard.fetchCurrentEpisode()
        configureHomePlayerView()
        configureCategoryViews()
        configureCurrentlyListeningLabel()
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
    
    fileprivate func configureCategoryViews() {
        
        let comedyView = HomeCategorySectionView(category: .comedy)
        comedyView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(comedyView)

        comedyView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 8).isActive = true
        comedyView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8).isActive = true
        comedyView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8).isActive = true
        comedyView.heightAnchor.constraint(equalToConstant: categoryHeigth).isActive = true

        let newsView = HomeCategorySectionView(category: .health)
        newsView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(newsView)

        newsView.topAnchor.constraint(equalTo: comedyView.bottomAnchor).isActive = true
        newsView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8).isActive = true
        newsView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8).isActive = true
        newsView.heightAnchor.constraint(equalToConstant: categoryHeigth).isActive = true
        
        let businessView = HomeCategorySectionView(category: .business)
        businessView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(businessView)

        businessView.topAnchor.constraint(equalTo: newsView.bottomAnchor).isActive = true
        businessView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8).isActive = true
        businessView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8).isActive = true
        businessView.heightAnchor.constraint(equalToConstant: categoryHeigth).isActive = true
        
        let sportsView = HomeCategorySectionView(category: .sports)
        sportsView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(sportsView)

        sportsView.topAnchor.constraint(equalTo: businessView.bottomAnchor).isActive = true
        sportsView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8).isActive = true
        sportsView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8).isActive = true
        sportsView.heightAnchor.constraint(equalToConstant: categoryHeigth).isActive = true
        
        sportsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 8).isActive = true
    }
    
    fileprivate func configureHomePlayerView() {
        let height: CGFloat = playerView.currentEpisode == nil ? 0 : 176
        
        scrollView.addSubview(playerView)
        playerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 84).isActive = true
        playerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 16).isActive = true
        playerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,constant: -16).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        playerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -32).isActive = true
    }

    @objc private func didTapHomePlayerView() {
        guard let audioPlayer = UIApplication.mainTabBarController()?.audioPlayerView else {return}
        if audioPlayer.episode == nil {
            audioPlayer.persistedProgress = UserDefaults.standard.cmtime(forKey: UserDefaults.currentTimeKey)
            audioPlayer.episode = playerView.currentEpisode
        }
        audioPlayer.handleTapMaximize()
    }
}
