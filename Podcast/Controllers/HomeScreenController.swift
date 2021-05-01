//
//  HomeScreenController.swift
//  Podcast
//
//  Created by Mo on 2021-04-30.
//

import UIKit

class HomeScreenController: UIViewController {

    var playerView: HomePagePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        playerView = HomePagePlayerView.initFromNib()
        playerContainerView.addSubview(playerView)
        
        playerView.topAnchor.constraint(equalTo: playerContainerView.topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: playerContainerView.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: playerContainerView.trailingAnchor).isActive = true
        playerView.layer.cornerRadius = 16
//        playerView.layer.borderColor = UIColor.gray.cgColor
//        playerView.layer.borderWidth = 2
//        playerView.layer.applySketchShadow(spread: 1.0)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.layoutIfNeeded()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView.currentEpisode = UserDefaults.standard.fetchCurrentEpisode() 
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBOutlet weak var playerContainerView: UIView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
