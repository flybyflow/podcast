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
    
    lazy var categoryNameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 8).isActive = true
        label.font = label.font.withSize(24)
        
        return label
    }()
    
    init(category: Category) {
        super.init(frame: .zero)
        
        categoryNameLabel.text = category.rawValue.capitalized
        
        podcastsCollectionView.delegate = self
        podcastsCollectionView.dataSource = self
        podcastsCollectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellID)
        addSubview(podcastsCollectionView)
        
        podcastsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        podcastsCollectionView.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 8).isActive = true
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
        cell.imageView.layer.cornerRadius = 16
        cell.imageView.clipsToBounds = true
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
        let width = 160
        return CGSize(width: width, height: width + 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesVC = EpisodesVC()
        episodesVC.podcast = podcasts[indexPath.row]
        
        findViewController()?.navigationController?.pushViewController(episodesVC, animated: true)
    }
}
