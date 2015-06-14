//
//  Book.swift
//  Capture
//
//  Created by Tatiana Magdalena on 5/23/15.
//  Copyright (c) 2015 Tatiana Magdalena. All rights reserved.
//


import Foundation

class Book {
    
    var title: String!
    var cover: Media!
    var media: [Media]!

    var author: String?
    var synopsis: String?
    var category: String?
    
    init(title: String, cover: Media, media: [Media]) {
        self.title = title
        self.cover = cover
        self.media = media
    }
}