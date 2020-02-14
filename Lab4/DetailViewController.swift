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
    @IBOutlet weak var scrollView: UIScrollView!
    
    var entry: PhotoEntry?
    var changed : Bool = false
    let OFFSET : CGFloat = 10
    
    //Mark - Delegate Functions
    //called when a view has been fully loaded into memory with all outlets initialized
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.image = entry?.photo
        notesView.text = entry?.notes
        //tying the UITextViewDelegate to the DetailViewController
        notesView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared), name: UIWindow.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared), name: UIWindow.keyboardDidHideNotification, object: nil)
    }
    //function is invoked everytime the text is changed
    func textViewDidChange(_ textView: UITextView) {
        entry?.notes = textView.text
        changed = true
    }
    
    @objc func keyboardAppeared(_ notification: NSNotification) {
        guard let frameValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let frame = frameValue.cgRectValue
        scrollView.contentInset.bottom = frame.size.height + OFFSET
        scrollView.verticalScrollIndicatorInsets.bottom = frame.size.height + OFFSET
    }
    
    @objc func keyboardDisappeared(_ notificatiojn: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

