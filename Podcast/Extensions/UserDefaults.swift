//
//  UserDefaults.swift
//  Podcast
//
//  Created by Mo on 2021-04-21.
//

import Foundation
import CoreMedia

extension UserDefaults {
    static let favoritesKey = "favoritePodcastsKey"
    static let currentEpisodeKey = "currentEpisodeKey"
    static let currentTimeKey = "currentTimeKey"
    
    func saveFavorite(podcast: Podcast) {
        var favoritePodcasts = fetchFavorites()
        favoritePodcasts.append(podcast)
        
        //Remove Duplicates
        favoritePodcasts = Array(Set(favoritePodcasts))
        
        do{
            let data = try JSONEncoder().encode(favoritePodcasts)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritesKey)
            
        }catch let error{
            print("Failed to save: Error: \(error)")
        }
    }
    
    func fetchFavorites() -> [Podcast] {
        do{
            if let data = UserDefaults.standard.data(forKey: UserDefaults.favoritesKey){
                let favoritePodcasts = try JSONDecoder().decode([Podcast].self, from: data)
                print(favoritePodcasts)
                return favoritePodcasts
            }
            
        }catch let error {
            print("Failed to save: Error: \(error)")
            return []
        }
        return []
    }
    
    func deleteFavorite(podcast: Podcast) {
        var favoritePodcasts = fetchFavorites()
        favoritePodcasts.removeAll { $0.name == podcast.name}
        
        do{
            let data = try JSONEncoder().encode(favoritePodcasts)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritesKey)
            
        }catch let error{
            print("Failed to save: Error: \(error)")
        }
    }
    
    // MARK: -Current Episode
    
    func saveCurrentEpisode(episode: Episode) {
        do{
            let data = try JSONEncoder().encode(episode)
            UserDefaults.standard.set(data, forKey: UserDefaults.currentEpisodeKey)
            
        }catch let error{
            print("Failed to save: Error: \(error)")
        }
    }
    
    func fetchCurrentEpisode() -> Episode? {
        do{
            if let data = UserDefaults.standard.data(forKey: UserDefaults.currentEpisodeKey){
                let currentEpisode = try JSONDecoder().decode(Episode.self, from: data)
                return currentEpisode
            }
            
        }catch let error {
            print("Failed to save: Error: \(error)")
            return nil
        }
        return nil
    }
}
// MARK: -CMTime

extension UserDefaults {
    func cmtime(forKey key: String) -> CMTime? {
        if let timescale = object(forKey: key + ".timescale") as? NSNumber {
            let seconds = double(forKey: key + ".seconds")
            return CMTime(seconds: seconds, preferredTimescale: timescale.int32Value)
        } else {
            return nil
        }
    }
    
    func set(_ cmtime: CMTime, forKey key: String) {
        let seconds = cmtime.seconds
        let timescale = cmtime.timescale
        
        set(seconds, forKey: key + ".seconds")
        set(NSNumber(value: timescale), forKey: key + ".timescale")
    }
}
