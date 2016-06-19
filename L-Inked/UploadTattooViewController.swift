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
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UploadTattooViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillAppear(_:)) , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
        

        
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
    
    /*
     
     let alertController = UIAlertController(title: "Default AlertController", message: "A standard alert", preferredStyle: .Alert)
     
     let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
     println("you have pressed the Cancel button");
     }
     alertController.addAction(cancelAction)
     
     let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
     println("you have pressed OK button");
     }
     alertController.addAction(OKAction)
     
     self.presentViewController(alertController, animated: true, completion:nil)
     
     */
    
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        
        //sender.userInteractionEnabled = false
        view.userInteractionEnabled = false
        
        if tattooToUpload.image == nil || tattooToUpload.image == UIImage(named: "addpic_copy") {
            let saveAlertController = UIAlertController(title: "No Photo Selected", message: "Please upload or take a photo with the camera button", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                
            })
            
            saveAlertController.addAction(okAction)
            self.presentViewController(saveAlertController, animated: true, completion: nil)
            
        } else {
        
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
                successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(successAlert, animated: true, completion: nil)
                
                self.view.userInteractionEnabled = true
                
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
                
                self.view.userInteractionEnabled = true

            }
        })
        
        }
        
        
    }
    

    @IBAction func cancelButtonPressed(sender: UIButton) {
        tattooToUpload.image = nil
        tattooToUpload.image = UIImage(named: "addpic_copy")
        tattooDescriptionTextField.text = ""
    }

    @IBAction func addImageButtonPressed(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
        }
        
        alertController.addAction(cancelAction)
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .Default) { (action:UIAlertAction) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.delegate = self
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
        alertController.addAction(libraryAction)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default) { (action:UIAlertAction) in
            let cameraPickerController = UIImagePickerController()
            cameraPickerController.sourceType = .Camera
            cameraPickerController.delegate = self
            self.presentViewController(cameraPickerController, animated: true, completion: nil)
        }
        
        alertController.addAction(cameraAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)


    }
    
//    @IBAction func takePhotoButtonPressed(sender: UIButton) {
        
//        let alertController = UIAlertController(title: "Photo AlertController", message: nil, preferredStyle: .ActionSheet)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
//            print("cancelled")
//        }
//        
//        alertController.addAction(cancelAction)
//        
//        let libraryAction = UIAlertAction(title: "Photo Library", style: .Default) { (action:UIAlertAction) in
//                    let imagePickerController = UIImagePickerController()
//                    imagePickerController.sourceType = .PhotoLibrary
//                    imagePickerController.delegate = self
//                    self.presentViewController(imagePickerController, animated: true, completion: nil)
//        }
//        
//        alertController.addAction(libraryAction)
//        
//        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default) { (action:UIAlertAction) in
//            let cameraPickerController = UIImagePickerController()
//            cameraPickerController.sourceType = .Camera
//            cameraPickerController.delegate = self
//            self.presentViewController(cameraPickerController, animated: true, completion: nil)
//        }
//        
//        alertController.addAction(cameraAction)
//        
//        self.presentViewController(alertController, animated: true, completion: nil)

        
//    }
    
    
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
