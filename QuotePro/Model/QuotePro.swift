//
//  QuotePro.swift
//  QuotePro
//
//  Created by Jamie on 2018-09-12.
//  Copyright © 2018 Jamie. All rights reserved.
//

import UIKit

class QuotePro: NSObject {

    var quote: Quote
    var photo: Photo
    
    init(quote:Quote , photo: Photo) {
        self.quote = quote
        self.photo = photo
        super.init()
    }
    
}
