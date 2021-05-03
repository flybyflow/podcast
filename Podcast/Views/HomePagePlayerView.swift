//
//  homePagePlayerView.swift
//  Podcast
//
//  Created by Mo on 2021-04-30.
//

import UIKit
import AVKit
import M13ProgressSuite

class HomePagePlayerView: UIControl {
    
    static func initFromNib() -> HomePagePlayerView {
        let player = Bundle.main.loadNibNamed("HomePagePlayer", owner: self, options: nil)?.first as! HomePagePlayerView
        
        //Setup CurrentTime Notification
        NotificationCenter.default.addObserver(player, selector: #selector(handleCurrentTimeChanged), name: .currentTime, object: nil)
        
        return player
    }
    
    private func configurePlayerUI() {
        //Setup ProgressImageView
        progressView.drawGreyscaleBackground = false
        progressView.progressDirection = M13ProgressViewImageProgressDirectionLeftToRight
        progressView.progressImage = #imageLiteral(resourceName: "Audio Wave")
        
        //Setup Current Time Label
        guard let currentTime = UserDefaults.standard.cmtime(forKey: UserDefaults.currentTimeKey) else {return}
        currentTimeLabel.text = currentTime.toDisplayString()
        
        //Setup Progress
        setProgressView(currentTime: currentTime)
    }

    var currentEpisode: Episode? {
        didSet {
            titleLabel.text = currentEpisode?.name ?? ""
            authorLabel.text = currentEpisode?.author ?? ""
            
            if let duration = currentEpisode?.duration {
                let time = CMTimeMakeWithSeconds(duration, preferredTimescale: 1)
                totalTimeLabel.text = time.toDisplayString()
            }
            
            if let url = URL(string: currentEpisode?.imageUrlString ?? "") {
                imageView.sd_setImage(with: url)
            }
            
            configurePlayerUI()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var progressImageView: UIImageView!
    @IBOutlet weak var progressView: M13ProgressViewImage!
        
    @objc func handleCurrentTimeChanged(notification: NSNotification) {
        guard let currentTime = notification.object as? CMTime else {return}
        currentTimeLabel.text = currentTime.toDisplayString()
        setProgressView(currentTime: currentTime)
        
    }
    
    private func setProgressView(currentTime: CMTime) {
        let currentSeconds = CGFloat(currentTime.seconds)
        let totalSeconds = CGFloat(currentEpisode!.duration)
        
        progressView.setProgress(currentSeconds/totalSeconds, animated: false)
    }
}
