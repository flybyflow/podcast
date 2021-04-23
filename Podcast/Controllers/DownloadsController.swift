//
//  DownloadsController.swift
//  Podcast
//
//  Created by Mo on 2021-03-01.
//

import UIKit
import CoreData

class DownloadsController: UITableViewController {
    
    static var downloadedEpisodes = [Episode]()
    
    let cellIdentifier = "cell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        guard let tabItems = UIApplication.mainTabBarController()?.tabBar.items else {return}
        tabItems[2].badgeValue = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        
        self.title = "Downloads"
        
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleDownloadProgress), name: .downloadProgress, object: nil)
    }
    
    @objc private func handleDownloadProgress(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String:Any],
              let progress = userInfo["progress"] as? Double,
              let title = userInfo["title"] as? String,
              let index = DownloadsController.downloadedEpisodes.firstIndex(where: {$0.name == title}),
              let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell
        else {return}
        cell.progressLabel.isHidden = false
        cell.progressLabel.text = "\(Int(progress*100))%"
        
        if progress == 1 {
            cell.progressLabel.isHidden = true
        }
        
        print(progress, title)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EpisodeCell
        cell.episode = DownloadsController.downloadedEpisodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DownloadsController.downloadedEpisodes.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = DownloadsController.downloadedEpisodes[indexPath.row]
        Audio.loadAudioPlayer(episode: episode, playlistEpisodes: DownloadsController.downloadedEpisodes)
    }
}

