//
//  DetailViewController.swift
//  Lab4
//
//  Created by PT X02b on 2020-01-31.
//  Copyright © 2020 ics069. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class DetailViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK - Properties
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var camButton: UIBarButtonItem!
    @IBOutlet weak var date: UIDatePicker!
    
    //class variables
    var entry: PhotoEntry?
    var notesDidChange : Bool = false
    let OFFSET : CGFloat = 10
    var photoDidChange : Bool = false
    var dateDidChange : Bool = false
    
    
    //MARK - Delegate Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.image = entry?.photo
        notesView.text = entry?.notes
        date.setDate(_: entry?.date.date ?? UIDatePicker().date, animated: false)
        //tying the UITextViewDelegate to the DetailViewController
        notesView.delegate = self
        date.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared), name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared), name: UIWindow.keyboardDidHideNotification, object: nil)
        if (photoView.image == nil) {
            camButton.isEnabled = false
            date.isHidden = true
        }
        else {
            camButton.isEnabled = true
            date.isHidden = false
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        entry?.notes = textView.text
        notesDidChange = true
    }
    
    //PURPOSE: checks if the current picture from the application was changed by the user, if it was changed it would set the PhotoEntry picture to the changed picture and set a flag to the save the current picture 
    //PARAMETERS: photoView -> valid photo
    //RETURN/SIDE EFFECTS: N/A
    //NOTES: Exceptions are not caught
   func photoViewDidChange(_ photoView: UIImageView) {
        entry?.photo = photoView.image!
        photoDidChange = true
   }
    
    //PURPOSE: displays the keyboard and sets the scrollview at the bottom to be the size of the frame + a constant offset and then sets the vertical scroll indicator to be the size of the frame + the offset
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
    
    //PURPOSE: hides the keyboard and sets the scrollView at the bottom to 0 and the scroll views vertical scroll indicator at the bottom to be 0
    //PARAMETERS: valid notification
    //RETURN/SIDE EFFECTS: N/A
    //NOTES: Exceptions are not caught
    @objc
    func keyboardDisappeared(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    //PURPOSE: upon the camera button press, the application will first check if the user has a camera to the device running the application and if so the application will prompt the user to access its camera (if its the user's first time pressing the camera button) then takes a picture with the devices camera.
    //PARAMETERS: sender -> valid action
    //RETURN/SIDE EFFECTS: N/A
    //NOTES: Exceptions are not caught
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
    
    //PURPOSE: upon a double tap gesture on the photo of the component, the system will either notify the user to access the gallery (if its the first time) or change the standard photo to a photo from the user's device's gallery
    //PARAMETERS: sender -> valid action (double tapping) in the application
    //RETURN/SIDE EFFECTS: If it is the first time double tapping the image, the application will prompt the user to allow the user to access their gallery in their device
    //NOTES: Exceptions are not caught
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized {
                DispatchQueue.main.async {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .photoLibrary
                    imagePickerController.delegate = self
                    self.present(imagePickerController, animated: true, completion: nil)
                }
            }
        })
    }
    
    //PURPOSE: assigns PhotoEntry date to whatever the user assigned date to be in the application and then checks if the date component in the application changed in the detail view component has changed from the original date that was set
    //PARAMETERS: sender -> valid action
    //RETURN/SIDE EFFECTS: N/A
    //NOTES: Exceptions are not caught
    @objc func dateChanged(_ sender: UIDatePicker) {
        entry?.date = date
        dateDidChange = true
    }
}

