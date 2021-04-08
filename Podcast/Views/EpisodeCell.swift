//
//  EpisodeCell.swift
//  Podcast
//
//  Created by Mo on 2021-02-04.
//

import UIKit
import SDWebImage

class EpisodeCell: UITableViewCell {

    var episode: Episode! {
        didSet {

            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            dateLabel.text = formatter.string(from: episode.date)
            
            titleLabel.text = episode.name
            descriptionLabel.text = episode.description.description
            
            guard let imageUrl = URL(string: episode.imageUrlString ?? "") else {return}
            episodeImageView.sd_setImage(with: imageUrl)
        }
    }
    
    @IBOutlet var episodeImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    

    
    
}
