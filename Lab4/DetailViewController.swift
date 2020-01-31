//
//  DetailViewController.swift
//  Lab4
//
//  Created by PT X02b on 2020-01-31.
//  Copyright © 2020 ics069. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK - Properties
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var photoView: UIImageView!
    var entry: PhotoEntry?
    
    //Mark - Delegate Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.image = entry?.photo
        notesView.text = entry?.notes
    }

}

