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
    
    
    
    //MARK: View Controller life cycle
    
    //MARK: Actions
    
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        
        let user = PFUser.currentUser()
        let newTat = Tattoo()
        
        if let tatDescription = tattooDescriptionTextField.text,
            tattooPic = tattooToUpload.image {
                
                
                newTat.setObject(user!, forKey: "TattooArtist")
                newTat.setObject(tatDescription, forKey: "TattooDescription")
                
                var pictureData = UIImagePNGRepresentation(tattooPic)!
                while pictureData.length > 500000 {
                    pictureData = UIImageJPEGRepresentation(tattooPic, 0.5)!
                }
                
                let imageFile = PFFile(name: "image.png", data: pictureData)
                
                newTat.setObject(imageFile!, forKey: "TattooImage")
                
                newTat.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success {
                        print("saved tat")
                    } else {
                        print("Error: \(error)")
                    }
                })

        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        tattooToUpload.image = nil
    }
    
    @IBAction func addImageButtonPressed(sender: UIBarButtonItem) {
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

}
