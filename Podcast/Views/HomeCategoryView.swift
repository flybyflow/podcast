//
//  HomeCategorySectionView.swift
//  Podcast
//
//  Created by Mo on 2021-05-04.
//

import UIKit

class HomeCategorySectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var podcasts = [Podcast]()
    private let cellID = "cellID"
    
    init(category: Category) {
        super.init(frame: .zero)
        
        podcastsCollectionView.delegate = self
        podcastsCollectionView.dataSource = self
        podcastsCollectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellID)
        addSubview(podcastsCollectionView)
        
        podcastsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        podcastsCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        podcastsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        podcastsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        podcastsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        podcastsCollectionView.backgroundColor = .clear
        
        layoutIfNeeded()
        
        Api.shared.fetchPodcasts(with: "podcast", category: category, count: 10,
                                 errorHandler: {
                                    print("Networking Error")
                                 },
                                 completionHandler: { (podcasts) in
                                    self.podcasts = podcasts
                                    DispatchQueue.main.async {
                                        self.podcastsCollectionView.reloadData()
                                    }
                                 })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? FavoritePodcastCell
        else {return UICollectionViewCell()}
        
        cell.podcast = podcasts[indexPath.row]
        return cell
    }
    
    let podcastsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (bounds.size.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
