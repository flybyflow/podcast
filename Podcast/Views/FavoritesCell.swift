//
//  FavoritesCell.swift
//  Podcast
//
//  Created by Mo on 2021-04-21.
//

import UIKit

class FavoritesCell: UICollectionViewCell {
    
    let titleLabel =  UILabel()
    let artistLabel = UILabel()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "Favorites"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.text = "Title"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        artistLabel.text = "Artist"
        artistLabel.font = UIFont.systemFont(ofSize: 12)
        
        let stackView = UIStackView(arrangedSubviews: [imageView,titleLabel,artistLabel])
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
