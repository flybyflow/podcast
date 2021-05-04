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
    
    var podcasts = [Podcast]()
    var playerView: HomePagePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomePlayerView()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        categoryTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        Api.shared.fetchPodcasts(with: "podcast", category: .comedy,
                                 errorHandler: {
                                    print("Networking Error")
                                 },
                                 completionHandler: { (podcasts) in
                                    self.podcasts = podcasts
                                    DispatchQueue.main.async {
                                        self.categoryTableView.reloadData()
                                    }
                                 })
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
    @IBOutlet weak var categoryTableView: UITableView!
}

extension HomeScreenController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PodcastCell else {return UITableViewCell()}
        
        cell.podcast = podcasts[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}
