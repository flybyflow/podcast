//
//  audioPlayer.swift
//  Podcast
//
//  Created by Mo on 2021-02-27.
//

import UIKit
import SDWebImage
import AVKit

class AudioPlayerView: UIView {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        observeAudioStarting()
        observeCurrentTime()
        setupGestures()
    }

    static func initFromNib() -> AudioPlayerView {
        return Bundle.main.loadNibNamed("audioPlayer", owner: self, options: nil)?.first as! AudioPlayerView
    }
    
    var episode: Episode! {
        didSet {
            playEpisode()
            
            nameLabel.text = episode.name
            miniNameLabel.text = episode.name
            authorLabel.text = episode.author
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
              
            guard let url = URL(string: episode.imageUrlString ?? "") else {return}
            imageView.sd_setImage(with: url)
            miniImageView.sd_setImage(with: url)
            
        }
    }
     
    func observeCurrentTime() {
        let interval = CMTimeMake(value: 1,timescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.updateSlider(currentTime: time)
            self?.updateCurrentTimeLabel(currentTime: time)
            self?.updateTotalTimeLabel()
        }
    }
    
    fileprivate func observeAudioStarting() {
        let time = CMTimeMake(value: 1, timescale: 1)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            //Enlarge Image
            self?.enlargeEpisodeImageView()
        }
    }
    
    private func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn)
        {
            self.imageView.transform = .identity
        }
    }
    
    private func minimizeEpisodeImageView() {
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn)
        {
            self.imageView.transform = self.imageViewtransformValue
        }
    }
    
    func updateSlider(currentTime: CMTime) {
        guard let totalTime = player.currentItem?.duration else {return}
        let percentage = CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(totalTime)
        
        timeSlider.value = Float(percentage)
        
    }
    
    func updateTotalTimeLabel() {
        totalTimeLabel.text = player.currentItem?.duration.toDisplayString()
            ?? CMTimeMake(value: 1, timescale: 1).toDisplayString()
    }
    
    func updateCurrentTimeLabel(currentTime: CMTime) {
        currentTimeLabel.text = currentTime.toDisplayString()
    }
    
    func seekFromCurrentTime(by value: Int){
        let modifierInSeconds = CMTimeMake(value: Int64(value), timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), modifierInSeconds)
        player.seek(to: seekTime)
    }
    
    private let imageViewtransformValue = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    @IBOutlet var imageView: UIImageView! {
        didSet {
            imageView.transform = imageViewtransformValue
            imageView.layer.cornerRadius = 5
            imageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var maximizedStackedView: UIStackView!
    
    @IBOutlet var nameLabel: UILabel! 
    @IBOutlet var authorLabel: UILabel!
    
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var timeSlider: UISlider!
    
    @IBOutlet var playPauseButton: UIButton!
    
    
    @IBOutlet weak var miniImageView: UIImageView!
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    @IBOutlet weak var miniNameLabel: UILabel!
    
    
    
    @IBAction func handleCurrentTimeChange() {
        let percentage = timeSlider.value
        guard let totalDuration = player.currentItem?.duration else {return}
        let totalDurationInSeconds = CMTimeGetSeconds(totalDuration)
        let seekTimeInSeconds = totalDurationInSeconds * Float64(percentage)
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
        
        player.play()
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
    }
    
    @IBAction func handleFastForward() {
        seekFromCurrentTime(by: 15)
    }
    @IBAction func handleRewind() {
        seekFromCurrentTime(by: -15)
    }
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    let player: AVPlayer = {
        let player = AVPlayer()
        //Remove Audio Delay
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    func playEpisode() {
        
        if episode.localAudioUrl != nil {
            
            guard let fileUrl = URL(string: episode.localAudioUrl ?? "")?.lastPathComponent else { return }
            guard var fileLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            fileLocation.appendPathComponent(fileUrl)
            
            let playerItem = AVPlayerItem(url: fileLocation)
            player.replaceCurrentItem(with: playerItem)
            player.play()
            
            print("Playing with local file at ", fileLocation)
        } else {
            guard let url = URL(string: episode.audioUrl) else {return}
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
        
        
        
        
    }
    
    
    @IBAction func didTapDismissBtn(_ sender: Any) {
        UIApplication.mainTabBarController()?.minimizePlayer()
    }
    
    @IBAction func didTapPlayPauseBtn(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            minimizeEpisodeImageView()
        }
        
    }
    
}

