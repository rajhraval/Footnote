//
//  MediaTypes.swift
//  Footnote
//
//  Created by Chaithra Pabbathi on 9/30/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//
//  This file is used to fix Issue #17 (adding different media types)

import Foundation

enum MediaType: Int {
    case book = 0
    case podcast
    case movie
    case tvShow
    
    func rawCoreDataValue() -> Int16 {
        Int16(self.rawValue)
    }
}

struct MediaTypeImageSystemName {
    static var bookImageName = "book.circle.fill"
    static var podcastImageName = "mic.circle.fill"
    static var movieImageName = "film.fill"
    static var tvShowImageName = "tv.circle.fill"
    
    static func getImage(forMediaType mediaType: MediaType) -> String {
        switch mediaType {
        case .book:
            return bookImageName
        case .podcast:
            return podcastImageName
        case .movie:
            return movieImageName
        case .tvShow:
            return tvShowImageName
        }
    }
}
