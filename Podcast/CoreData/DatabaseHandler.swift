//
//  DatabaseHandler.swift
//  Podcast
//
//  Created by Mo on 2021-03-01.
//

import UIKit
import CoreData


class DatabaseHandler {
    
    private init() {}
    static var shared = DatabaseHandler()
    
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func fetchDownloadedEpisodes() -> [Episode] {
        
        let context = container.newBackgroundContext()
        let request: NSFetchRequest<CoreDataEpisode> = CoreDataEpisode.fetchRequest()
        
        do {
            let matches = try context.fetch(request)
            var downloadedEpisodes = [Episode]()
            matches.forEach { (CoreDataEpisode) in
            let episode = Episode(coreDataEpisode: CoreDataEpisode)
                downloadedEpisodes.append(episode)
            }
            return downloadedEpisodes
        }
        catch {
            print(error)
        }
        return []
    }

    func findOrCreateEpisode(_ episode: Episode) -> CoreDataEpisode? {
        
        let context = container.newBackgroundContext()
        
        let request: NSFetchRequest<CoreDataEpisode> = CoreDataEpisode.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", episode.name)
        
        do {
            let matches = try context.fetch(request)
            if !matches.isEmpty {
                return matches.first
            }
        }
        catch {
            print(error)
        }
        
        let coreDataEpisode = CoreDataEpisode(context: context)
        
        coreDataEpisode.localAudioUrl = episode.localAudioUrl
        coreDataEpisode.author = episode.author
        coreDataEpisode.date = episode.date
        coreDataEpisode.imageUrlString = episode.imageUrlString
        coreDataEpisode.name = episode.name
        coreDataEpisode.episodeDescription = episode.description
        
        try? context.save()
        return nil
    }
}
