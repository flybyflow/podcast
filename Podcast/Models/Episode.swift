//
//  Episode.swift
//  Podcast
//
//  Created by Mo on 2021-02-04.
//

import Foundation
import FeedKit
import CoreData


struct Episode: Equatable {
    let name: String
    let description: String
    let date: Date
    var imageUrlString: String?
    let audioUrl: String
    let author: String
    var localAudioUrl: String?
    
    
    init(feedItem: RSSFeedItem) {
        self.name = feedItem.title ?? ""
        self.description = feedItem.iTunes?.iTunesSummary ?? feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.date = feedItem.pubDate ?? Date()
        self.imageUrlString = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.audioUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
    }
    
    init(coreDataEpisode: CoreDataEpisode) {
        self.name = coreDataEpisode.name!
        self.description = coreDataEpisode.episodeDescription!
        self.date = coreDataEpisode.date!
        self.imageUrlString = coreDataEpisode.imageUrlString
        self.audioUrl = ""
        self.author = coreDataEpisode.author!
        self.localAudioUrl = coreDataEpisode.localAudioUrl
    }
    
//    init(feedItem: JSONFeedItem) {
//        self.name = feedItem.title ?? ""
//        self.description = feedItem.summary ?? ""
//        self.date = feedItem.datePublished ?? Date()
//        self.imageUrlString = feedItem.image ?? ""
//        self.audioUrl = feedItem.url ?? ""
//        self.author = feedItem.author?.name ?? ""
//    }

}
