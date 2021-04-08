//
//  String.swift
//  Podcast
//
//  Created by Mo on 2021-02-04.
//

import Foundation

extension String {
    func toSecureHttps() -> URL? {
        
        let secureUrlString = self.contains("https") ? self :
            self.replacingOccurrences(of: "http", with: "https")
        
        let feedUrl = URL(string: secureUrlString)
        
        return feedUrl
    }
}
