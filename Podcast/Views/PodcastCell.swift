//
//  PodcastCell.swift
//  Podcast
//
//  Created by Mo on 2021-02-01.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet var podcastImage: UIImageView?
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    
    
    var podcast: Podcast! {
        didSet {
            nameLabel.text = podcast.name
            authorLabel.text = podcast.author
            countLabel.text = "\(podcast.episodeCount ?? 0) Episodes"
            
            guard let imageUrl = URL(string: podcast.imagePath ?? "") else {return}
                podcastImage?.sd_setImage(with: imageUrl, completed: nil)
        }
    }
}
