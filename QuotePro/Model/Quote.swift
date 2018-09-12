//
//  Quote.swift
//  QuotePro
//
//  Created by Jamie on 2018-09-12.
//  Copyright © 2018 Jamie. All rights reserved.
//

import UIKit

class Quote: NSObject {
    var content: String
    var author: String
    
    init(content: String, author: String) {
        self.content = content
        self.author = author
        super.init()
    }
}
