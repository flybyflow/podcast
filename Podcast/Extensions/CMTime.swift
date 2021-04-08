//
//  CMTime.swift
//  Podcast
//
//  Created by Mo on 2021-02-28.
//

import Foundation
import AVKit

extension CMTime {
    func toDisplayString() -> String {
        
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
            let totalSeconds = Int(CMTimeGetSeconds(self))
        
        let hours = totalSeconds / 3600
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) - (hours * 60)
        if totalSeconds < 3600 {
            let timeformatString = String(format: "%02d:%02d", minutes, seconds)
            return timeformatString
        } else {
            let timeformatString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            return timeformatString
        }
    }
}
