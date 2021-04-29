//
//  SearchNavController.swift
//  Podcast
//
//  Created by Mo on 2021-02-01.
//

import UIKit

class SearchNavController: UITableViewController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        setupTableView()
        setupSearchBar()
    }
    
    //MARK: - Constants
    
    let cellIdentifier = "cell"
    
    var podcasts = [Podcast]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Tableview Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PodcastCell else {return UITableViewCell()}
        
        cell.podcast = podcasts[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesVC = EpisodesVC()
        episodesVC.podcast = podcasts[indexPath.row]
        navigationController?.pushViewController(episodesVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Start Search"
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.isEmpty == true ? 250 : 0
    }
    
    //MARK: - SearchBar Methods
    
    private var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            Api.shared.fetchPodcasts(with: searchText,
                                     errorHandler: {
                                        DispatchQueue.main.async {
                                        self.displayNetworkingError()
                                        }
                                     },
                                     completionHandler: { (podcasts) in
                                        self.podcasts = podcasts
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
                                     })
        })
    }
    
    private func displayNetworkingError() {
        let alertController = UIAlertController(title: "Networking Error, Please Check Connection", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Setup Work
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        tableView.tableFooterView = UIView()
        title = "Search"
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}
