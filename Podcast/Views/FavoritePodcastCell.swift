//
//  FavoritesCell.swift
//  Podcast
//
//  Created by Mo on 2021-04-21.
//

import UIKit

class FavoritePodcastCell: UICollectionViewCell {
    
    var podcast: Podcast! {
        didSet {
            nameLabel.text = podcast.name
            authorLabel.text = podcast.author
            
            guard let url = URL(string: podcast.imagePath ?? "") else {return}
            imageView.sd_setImage(with: url)
        }
    }
    
    let nameLabel =  UILabel()
    let authorLabel = UILabel()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "Favorites"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameLabel.text = "Title"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        authorLabel.text = "Artist"
        authorLabel.font = UIFont.systemFont(ofSize: 12)
        
        let stackView = UIStackView(arrangedSubviews: [imageView,nameLabel,authorLabel])
        self.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
