//
//  loadAudioPlayer.swift
//  Podcast
//
//  Created by Mo on 2021-03-13.
//

import UIKit

class Audio {
    
    private init() {}
    
    static func loadAudioPlayer(episode: Episode, playlistEpisodes: [Episode] = []) {
        let mainTabController = UIApplication.mainTabBarController()
        mainTabController?.audioPlayerView.episode = episode
        mainTabController?.audioPlayerView.playlistEpisodes = playlistEpisodes
        mainTabController?.maximizePlayer()
    }
    
}
