//
//  Data.swift
//  TesteDAO2
//
//  Created by Tatiana Magdalena on 5/24/15.
//  Copyright (c) 2015 Tatiana Magdalena. All rights reserved.
//

import Foundation

private let data = Data()

class Data {
    
    var allBooks: [Book]!
    
    class var sharedInstance: Data {
        return data
    }
    
    init() {
        
    }
}