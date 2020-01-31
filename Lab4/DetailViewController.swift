//
//  DetailViewController.swift
//  Lab4
//
//  Created by PT X02b on 2020-01-31.
//  Copyright © 2020 ics069. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    
    // MARK - Properties
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var photoView: UIImageView!
    var entry: PhotoEntry?
    
    //Mark - Delegate Functions
    //called when a view has been fully loaded into memory with all outlets initialized
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.image = entry?.photo
        notesView.text = entry?.notes
        //tying the UITextViewDelegate to the DetailViewController
        notesView.delegate = self
    }
    //function is invoked everytime the text is changed
    func textViewDidChange(_ textView: UITextView) {
        entry?.notes = textView.text
    }
}

