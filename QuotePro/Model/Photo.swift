//
//  Photo.swift
//  QuotePro
//
//  Created by Jamie on 2018-09-12.
//  Copyright © 2018 Jamie. All rights reserved.
//

import UIKit

class Photo: NSObject {
    
    var name: String
    var url: String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
        super.init()
    }
}
