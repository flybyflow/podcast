//
//  SearchResults.swift
//  Podcast
//
//  Created by Mo on 2021-02-01.
//

import Foundation

struct SearchResults: Decodable {
    let resultCount: Int
    var results = [Podcast]()
    
   
}
