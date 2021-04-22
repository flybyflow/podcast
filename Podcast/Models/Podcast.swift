//
//  Podcast.swift
//  Podcast
//
//  Created by Mo on 2021-02-01.
//

import Foundation

struct Podcast: Codable, Hashable {
    
    var name: String?
    var author: String?
    var episodeCount: Int?
    var imagePath: String?
    var feedUrlString: String?

    
    enum CodingKeys : String, CodingKey {
        case name = "collectionName"
        case author = "artistName"
        case episodeCount = "trackCount"
        case imagePath = "artworkUrl100"
        case feedUrlString = "feedUrl"
    }
}


