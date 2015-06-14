//
//  Media.swift
//  Capture
//
//  Created by Tatiana Magdalena on 5/23/15.
//  Copyright (c) 2015 Tatiana Magdalena. All rights reserved.
//


import Foundation

class Media {
    
    var name: String!
    var path: String!
    var type: String!
    var description: String?
    
    init(name: String, path: String, type: String) {
        self.name = name
        self.path = path
        self.type = type
    }
}

