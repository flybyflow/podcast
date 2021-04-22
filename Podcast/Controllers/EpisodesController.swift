//
//  EpisodesVCswift.swift
//  Podcast
//
//  Created by Mo on 2021-02-02.
//

import UIKit
import FeedKit

class EpisodesVC: UITableViewController {
    
    var episodes = [Episode]()
    
    let cellId = "CellId"
    
    var podcast: Podcast! {
        didSet {
            navigationItem.title = podcast.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBarButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        FetchEpisodesFromNetwork()
    }
    
    @objc private func handleSaveFavorite() {
        UserDefaults.standard.saveFavorite(podcast: podcast)
        
        guard let tabItems = UIApplication.mainTabBarController()?.tabBar.items else {return}
        tabItems[1].badgeValue = "New"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "★", style: .plain, target: self, action: #selector(handleRemoveFavorite))
    }
    
    @objc private func handleRemoveFavorite() {
        UserDefaults.standard.deleteFavorite(podcast: podcast)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "☆", style: .plain, target: self, action: #selector(handleSaveFavorite))
    }
    
    // MARK: - Setup
    
    fileprivate func setupNavigationBarButtons() {
        let favoritePodcasts = UserDefaults.standard.fetchFavorites()
        let isFavorited: Bool = favoritePodcasts.contains(podcast)
        if isFavorited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "★", style: .plain, target: self, action: #selector(handleRemoveFavorite))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "☆", style: .plain, target: self, action: #selector(handleSaveFavorite))
        }
    }
    
    fileprivate func FetchEpisodesFromNetwork() {
        Api.shared.fetchEpisodes(with: podcast.feedUrlString,
                                 errorHandler: {
                                    DispatchQueue.main.async {
                                        self.displayNetworkingError()
                                    }
                                    
                                 },
                                 completionHandler:
                                    { (episodes) in
                                        self.episodes = episodes
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
                                    })
    }
    
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    private func displayNetworkingError() {
        let alertController = UIAlertController(title: "Networking Error, \n Please Check Connection", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? EpisodeCell
        else {return UITableViewCell()}
        cell.episode = episodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        
        Audio.loadAudioPlayer(episode: episode, playlistEpisodes: episodes)
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 100 : 0
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let downloadAction = UIContextualAction(style: .normal, title: "Download") { (_, _, _) in
            let episode = self.episodes[indexPath.row]
            Api.shared.download(episode, errorHandler: {
                self.displayNetworkingError()
                
            })
            
        }
        downloadAction.backgroundColor = .purple
        
        let config = UISwipeActionsConfiguration(actions: [downloadAction])
        return config
    }
}


