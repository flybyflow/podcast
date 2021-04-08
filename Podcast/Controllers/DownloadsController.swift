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
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DownloadsController.downloadedEpisodes = DatabaseHandler.shared.fetchDownloadedEpisodes()
        print("reloading Data")
        tableView.reloadData()
        
        self.title = "Downloads"
        
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
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
        Audio.loadAudioPlayer(episode: episode)
    }
}

