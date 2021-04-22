//
//  UserDefaults.swift
//  Podcast
//
//  Created by Mo on 2021-04-21.
//

import Foundation

extension UserDefaults {
    static let favoritesKey = "favoritePodcastsKey"
    
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
}
