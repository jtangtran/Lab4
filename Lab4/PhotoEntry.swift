//
//  PhotoEntry.swift
//  Lab4
//
//  Created by PT X02b on 2020-01-31.
//  Copyright © 2020 ics069. All rights reserved.
//

import UIKit

class PhotoEntry: NSObject {
    //MARK: - Properties
    var photo: UIImage
    var notes: String
    
    //MARK - Initializers
    init(photo: UIImage, notes: String) {
        self.photo = photo
        self.notes = notes
    }
}
