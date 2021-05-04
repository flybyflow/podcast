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
    
    enum Category: String {
        case news = "1489"
        case comedy = "1303"
        case culture = "1324"
        case health = "1512"
        case sports = "1545"
        case business = "1321"
    }
    
    func fetchPodcasts(with searchText: String, category: Category?, errorHandler: @escaping () -> Void, completionHandler: @escaping ([Podcast]) -> ()) {
        
        var parameters = ["term":searchText,
                          "media":"podcast"]
        
        if let categoryId = category?.rawValue {
            parameters["category"] = categoryId
        }
        
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
                    let episode = Episode(feedItem: feedItem)
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
    
    func download(_ selectedEpisode: Episode, errorHandler: @escaping  (AFError) -> Void ) {
        //Fetch Media Object
        var episode = selectedEpisode
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        AF.download(episode.audioUrl, to: downloadRequest)
            .downloadProgress { (progress) in
                //TODO: - Display Download Progress
                print(progress)
                
                NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.name,
                                                                                                "progress":progress.fractionCompleted])
                
            }
            .responseData { (response) in
                if let error = response.error {
                    errorHandler(error)
                }
                else {
                    let localUrl = response.fileURL?.absoluteString
                    episode.localAudioUrl = localUrl
                    
                    //Save Episode to Core Data
                    _ = DatabaseHandler.shared.findOrCreateEpisode(episode)
                    
                    //Update the episode with localAudioURL
                    let index = DownloadsController.downloadedEpisodes.firstIndex { (episodeToUpdate) -> Bool in
                        episodeToUpdate.name == episode.name &&
                            episodeToUpdate.author == episode.author
                    }
                    if index != nil {
                        DownloadsController.downloadedEpisodes[index!] = episode
                    }
                }
            }
    }
}
