//
//  Category.swift
//  Podcast
//
//  Created by Mo on 2021-05-04.
//

import Foundation

enum Category: String {
    case news
    case comedy
    case culture
    case health
    case sports
    case business
    
    var id: String {
        switch self {
        case .news : return "1489"
        case .comedy : return "1303"
        case .culture : return "1324"
        case .health : return "1512"
        case .sports : return "1545"
        case .business : return "1321"
        }
    }
}
