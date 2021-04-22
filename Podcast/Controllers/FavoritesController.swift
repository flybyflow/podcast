//
//  FavoritesController.swift
//  Podcast
//
//  Created by Mo on 2021-04-21.
//

import UIKit

private let reuseIdentifier = "Cell"

class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var favoritePodcasts = [Podcast]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Reload Favorites
        collectionView.reloadData()
        favoritePodcasts = UserDefaults.standard.fetchFavorites()
        
        //Reset Badge 
        guard let tabItems = UIApplication.mainTabBarController()?.tabBar.items else {return}
        tabItems[1].badgeValue = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    @objc func handleLongPressDelete(_ gesture: UIGestureRecognizer) {
        
        let tapLocation = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: tapLocation) else {return}
        
        let alertController = UIAlertController(title: "Remove from Favorites?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.removePodcast(at: indexPath)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in }))
        
        present(alertController, animated: true)
    }
    
    private func removePodcast(at indexPath: IndexPath) {
        let podcast = favoritePodcasts[indexPath.item]
        UserDefaults.standard.deleteFavorite(podcast: podcast)
        
        favoritePodcasts.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionViewLayout.collectionView?.backgroundColor = .white
        view.backgroundColor = .white

        title = "Favorites"
        collectionView!.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressDelete)))
    }
    
    // MARK: - CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.size.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 40)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePodcasts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FavoritePodcastCell else {return UICollectionViewCell()}
        cell.podcast = favoritePodcasts[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesVC = EpisodesVC()
        episodesVC.podcast = favoritePodcasts[indexPath.item]
        navigationController?.pushViewController(episodesVC, animated: true)
    }

}
