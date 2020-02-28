//
//  PhotoEntry.swift
//  Lab4
//
//  Created by PT X02b on 2020-01-31.
//  Copyright © 2020 ics069. All rights reserved.
//

import UIKit
import os

class PropertyKey {
    static let photo = "photo"
    static let notes = "notes"
    static let date = "date"
}

class PhotoEntry: NSObject, NSCoding {
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("entries")
    
    //MARK: - Properties
    //class variables
    var photo: UIImage
    var notes: String
    var date : UIDatePicker
    
    //MARK - Initializers
    
    //PURPOSE: initialize all the class variables
    //PARAMETERS: valid photo -> UIImage, valid notes -> String, valid date -> UIDatePicker
    //RETURN/SIDE EFFECTS: N/A
    //NOTES: Exceptions are not caught
    init(photo: UIImage, notes: String, date : UIDatePicker) {
        self.photo = photo
        self.notes = notes
        self.date = date
    }
    
    //MARK - Load/Save
    required convenience init?(coder aDecoder: NSCoder) {
        guard let newPhoto = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage else {
            os_log("Missing Image", log: OSLog.default, type: .debug)
            return nil
        }
        guard let newNotes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String else {
            os_log("Missing Notes", log: OSLog.default, type: .debug)
            return nil
        }
        guard let newDate = aDecoder.decodeObject(forKey: PropertyKey.date) as? UIDatePicker else {
            os_log("Missing Date", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(photo: newPhoto, notes: newNotes, date: newDate)
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(notes, forKey: PropertyKey.notes)
        aCoder.encode(date, forKey: PropertyKey.date)
    }
}
