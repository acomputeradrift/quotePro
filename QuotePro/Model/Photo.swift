//
//  Photo.swift
//  QuotePro
//
//  Created by Jamie on 2018-09-12.
//  Copyright © 2018 Jamie. All rights reserved.
//

import UIKit


class Photo: NSObject {
    
    var id: Int
    var width: Int
    var height: Int
    var url: String
    
    
    init(id: Int, url: String, width: Int, height: Int) {
        self.id = id
        self.width = width
        self.height = height
        self.url = url
        
        super.init()
    }
}
