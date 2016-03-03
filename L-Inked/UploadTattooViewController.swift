//
//  UploadTattooViewController.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-23.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse

class UploadTattooViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var tattooToUpload: UIImageView!
    @IBOutlet weak var tattooDescriptionTextField: UITextField!
    @IBOutlet weak var tattooImageTopConstraint: NSLayoutConstraint!
    
    var originalTopConstraint = CGFloat()
    
    
    //MARK: View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:" , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:" , name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        originalTopConstraint = tattooImageTopConstraint.constant
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: Actions
    
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        
        guard let user = LinkedUser.currentUser(),
            let tatDescription = tattooDescriptionTextField.text,
            let tattooPic = tattooToUpload.image else { return }
        
        let newTat = Tattoo()
        
        newTat.tattooArtist = user
        newTat.tattooDescription = tatDescription
        
        var pictureData = UIImagePNGRepresentation(tattooPic)!
        
        while pictureData.length > 5000000 {
            pictureData = UIImageJPEGRepresentation(tattooPic, 0.5)!
        }
        if let imageFile = PFFile(data: pictureData) {
            newTat.tattooImage = imageFile
            imageFile.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    print("success")
                }
            })
        }
        newTat.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                print("saved tat")
                
                let successAlert = UIAlertController(title: "Success", message: "Tattoo was successfully uploaded", preferredStyle: UIAlertControllerStyle.Alert)
                successAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(successAlert, animated: true, completion: nil)
                
                
                user.tattoos.append(newTat)
                
                user.saveInBackgroundWithBlock { (success, error) -> Void in
                    if success {
                        print("added tattoo to artists array")
                    } else {
                        print("error")
                    }
                }
            } else {
                print("Error: \(error)")
                let errorAlert = UIAlertController(title: "Error", message: "Error uploading tattoo", preferredStyle: UIAlertControllerStyle.Alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(errorAlert, animated: true, completion: nil)
            }
        })
        

    }

    @IBAction func cancelButtonPressed(sender: UIButton) {
        tattooToUpload.image = nil
    }

    @IBAction func addImageButtonPressed(sender: UIBarButtonItem) {
        
        let cameraPickerController = UIImagePickerController()
        cameraPickerController.sourceType = .Camera
        cameraPickerController.delegate = self
        presentViewController(cameraPickerController, animated: true, completion: nil)
        

    }
    
    @IBAction func takePhotoButtonPressed(sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
     
        
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        tattooToUpload.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: General Methods
    
    func keyboardWillAppear(notification: NSNotification) {
        
        
            if tattooDescriptionTextField.isFirstResponder() == true {
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    
                    let keyboardOrigin = view.frame.size.height - keyboardSize.height
                    
                    if tattooDescriptionTextField.frame.origin.y + tattooDescriptionTextField.frame.height > keyboardOrigin {
                        
                        let distanceToMoveConstraint = tattooDescriptionTextField.frame.origin.y - keyboardOrigin + tattooDescriptionTextField.frame.height + 10
                        tattooImageTopConstraint.constant -= distanceToMoveConstraint
                        UIView.animateWithDuration(0.5) { self.view.layoutIfNeeded()}
                        print(distanceToMoveConstraint)
                        
                    }
                }
            }
        
        
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        if tattooImageTopConstraint.constant != originalTopConstraint {
            tattooImageTopConstraint.constant = originalTopConstraint
            UIView.animateWithDuration(0.5) { self.view.layoutIfNeeded()}
            
        }
        
    }

    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }

}
