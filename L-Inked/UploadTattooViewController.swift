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
    
    //MARK: General Functions
    
    func addTattooToArray() {
        
    }

}
