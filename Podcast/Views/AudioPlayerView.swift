//
//  audioPlayer.swift
//  Podcast
//
//  Created by Mo on 2021-02-27.
//

import UIKit
import SDWebImage
import AVKit
import MediaPlayer

class AudioPlayerView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        observeAudioStarting()
        observeCurrentTime()
        setupGestures()
        setupBackgroundPlayback()
    }
    
    private func setupBackgroundInfo() {
        var nowPlayingInfo = [String:Any]()

        nowPlayingInfo =  [MPMediaItemPropertyArtist: episode.author,
                           MPMediaItemPropertyTitle: episode.name]

        if let image = imageView.image {
            let artwork = MPMediaItemArtwork(boundsSize: imageView.bounds.size) { (_) -> UIImage in
                return image
            }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    private func setupBackgroundPlayback() {
        try? AVAudioSession.sharedInstance().setActive(true)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.isEnabled = true
        
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayAudio()
            self.setLockScreenElapsedTime()
            return .success
        }
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePauseAudio()
            self.setLockScreenElapsedTime()
            return .success
        }
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.didTapPlayPauseBtn()
            self.setLockScreenElapsedTime()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            self.changeTrack(moveForward: true)
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            self.changeTrack(moveForward: false)
            return .success
        }
    }
    
    fileprivate func changeTrack(moveForward: Bool) {
        let offset = moveForward ? 1 : playlistEpisodes.count - 1
        if playlistEpisodes.count == 0 {return}
        let currentEpisodeIndex = playlistEpisodes.firstIndex { (episode) -> Bool in
            return self.episode.name == episode.name
        }
        guard let index = currentEpisodeIndex else {return}
        self.episode = playlistEpisodes[(index + offset) % playlistEpisodes.count]
    }

    static func initFromNib() -> AudioPlayerView {
        return Bundle.main.loadNibNamed("audioPlayer", owner: self, options: nil)?.first as! AudioPlayerView
    }
    
    var playlistEpisodes = [Episode]()
    var episode: Episode! {
        didSet {
            playEpisode()
            
            nameLabel.text = episode.name
            miniNameLabel.text = episode.name
            authorLabel.text = episode.author
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
              
            if let url = URL(string: episode.imageUrlString ?? "") {
                imageView.sd_setImage(with: url)
                miniImageView.sd_setImage(with: url)
            }
            setupBackgroundInfo()
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
        setLockScreenElapsedTime()
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
        
        setLockScreenElapsedTime()
        
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
    
    fileprivate func handlePlayAudio() {
        player.play()
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        enlargeEpisodeImageView()
    }
    
    fileprivate func handlePauseAudio() {
        player.pause()
        playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        minimizeEpisodeImageView()
    }
    
    @IBAction func didTapPlayPauseBtn() {
        if player.timeControlStatus == .paused {
            handlePlayAudio()
        } else {
            handlePauseAudio()
        }
    }
}

