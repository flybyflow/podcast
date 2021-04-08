//
//  Api.swift
//  Podcast
//
//  Created by Mo on 2021-02-01.
//

import Foundation
import Alamofire
import FeedKit

class Api {
    
    static let shared = Api()
    
    let baseItunesSearchUrl = "https://itunes.apple.com/search"
    
    func fetchPodcasts(with searchText: String, errorHandler: @escaping () -> Void, completionHandler: @escaping ([Podcast]) -> ()) {
        
        let parameters = ["term":searchText,
                          "media":"podcast"]
        
        AF.request(baseItunesSearchUrl,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: nil, interceptor: nil, requestModifier: nil).responseData { (dataResponse) in
                    
                    guard dataResponse.error == nil
                    else {
                        errorHandler()
                        return}
                    
                    guard let data = dataResponse.data else {return}
                    
                    do {
                        let searchResults = try JSONDecoder().decode(SearchResults.self,
                                                                     from: data)
                        completionHandler(searchResults.results)
                    }
                    catch {
                        print(error)
                    }
                   }
    }
    
    func fetchEpisodes(with feedUrlString: String?, errorHandler: @escaping () -> Void, completionHandler: @escaping ([Episode]) -> () ) {
        
        guard let feedUrlString = feedUrlString else {return}
        
        guard let feedUrl = feedUrlString.toSecureHttps() else {return}
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: feedUrl)
            let result = parser.parse()
            
            switch result {
            case .success(let feed):
                
                var episodes = [Episode]()
                
                feed.rssFeed?.items?.forEach({ (feedItem) in
                    var episode = Episode(feedItem: feedItem)
                    if episode.imageUrlString == nil {
                        episode.imageUrlString = feedItem.iTunes?.iTunesImage?.attributes?.href
                    }
                    episodes.append(episode)
                })
                
                
                //TODO: - Fix AtomFeed & JsonFeed
                
                DispatchQueue.main.async {
                    completionHandler(episodes)
                }
                
            case .failure:
                //Handle Errors
               errorHandler()
            }
        }
    }
    
    func download(_ selectedEpisode: Episode, errorHandler: @escaping  () -> Void ) {
        //Fetch Media Object
        var episode = selectedEpisode
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        AF.download(episode.audioUrl, to: downloadRequest).downloadProgress { (Progress) in
            //TODO: - Display Download Progress
        }.responseData { (response) in
            
            guard response.error == nil
            else {
                errorHandler()
                return}
            
            let localUrl = response.fileURL?.absoluteString
            episode.localAudioUrl = localUrl
            
            if DatabaseHandler.shared.findOrCreateEpisode(episode) == nil {
                DownloadsController.downloadedEpisodes.append(episode)
            }
        }
    }
}
