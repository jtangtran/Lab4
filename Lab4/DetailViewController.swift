//
//  DetailViewController.swift
//  Lab4
//
//  Created by PT X02b on 2020-01-31.
//  Copyright © 2020 ics069. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK - Properties
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var camButton: UIBarButtonItem!
    
    //class variables
    var entry: PhotoEntry?
    var notesDidChange : Bool = false
    let OFFSET : CGFloat = 10
    var photoDidChange : Bool = true
    
    //MARTK - Delegate Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.image = entry?.photo
        notesView.text = entry?.notes
        //tying the UITextViewDelegate to the DetailViewController
        notesView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared), name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared), name: UIWindow.keyboardDidHideNotification, object: nil)
        if (photoView.image == nil) {
            camButton.isEnabled = false
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        entry?.notes = textView.text
        notesDidChange = true
    }
    
   func photoViewDidChange(_ photoView: UIImageView) {
        entry?.photo = photoView.image!
        photoDidChange = true
   }
    
    //PURPOSE: displays the keyboard upon a notification event
    //PARAMETERS: valid notification
    //RETURN/SIDE EFFECTS: N/A
    //NOTES: Exceptions are not caught
    @objc
    func keyboardAppeared(_ notification: NSNotification) {
        guard let frameValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let frame = frameValue.cgRectValue
        scrollView.contentInset.bottom = frame.size.height + OFFSET
        scrollView.verticalScrollIndicatorInsets.bottom = frame.size.height + OFFSET
    }
    
    //PURPOSE: hides the keyboard upon a notification event
    //PARAMETERS: valid notification
    //RETURN/SIDE EFFECTS: N/A
    //NOTES: Exceptions are not caught
    @objc
    func keyboardDisappeared(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        //check if the device has a camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let alert = UIAlertController(title: "Camera Error", message: "Camera not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //launch the camera controller
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                DispatchQueue.main.async {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = UIImagePickerController.SourceType.camera
                    picker.allowsEditing = true
                    self.present(picker, animated: true, completion: nil)
                }
            }
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        photoViewDidChange(photoView)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

