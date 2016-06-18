//
//  EditProfileViewController.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-23.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var profilePicToUpload: UIImageView!
    @IBOutlet weak var artistNameTextField: UITextField!
    @IBOutlet weak var shopAddressTextField: UITextField!
    @IBOutlet weak var artistEmailTextField: UITextField!
    @IBOutlet weak var aboutArtistTextView: UITextView!
    @IBOutlet weak var profilePicTopConstraint: NSLayoutConstraint!
    
    
    var originalTopConstraint = CGFloat()
    var geoCoder = CLGeocoder()
    var shopGeopoint = PFGeoPoint()
    
    let tvPlaceholder = "Tell us about yourself in a few lines.."
    
    
    
    //MARK: View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureTextView()
        configureImageView()
        
        fillTextFieldsWithData()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillAppear(_:)) , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillDisappear(_:)) , name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        originalTopConstraint = profilePicTopConstraint.constant
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
         NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: Actions
    
    @IBAction func saveProfileButtonPressed(sender: UIButton) {
        let user =  LinkedUser.currentUser()
        
        if let user = user,
            name = artistNameTextField.text,
            contactEmail = artistEmailTextField.text,
            address = shopAddressTextField.text,
            about = aboutArtistTextView.text,
            profilePic = profilePicToUpload.image {
  
                user.name = name
                user.contactEmail = contactEmail
                user.shopAddress = address
                user.aboutArtist = about
    
                print(user.shopAddress)
                
              
                self.geoCoder.geocodeAddressString(user.shopAddress, completionHandler: { (placemarks: [CLPlacemark]?, error) -> Void in
                 
           
                        if let placemark = placemarks?.first {
                            
                            let geopoint = PFGeoPoint(latitude: (placemark.location?.coordinate.latitude)!, longitude: (placemark.location?.coordinate.longitude)!)
                            
                            self.shopGeopoint = geopoint
                            user.shopGeopoint = self.shopGeopoint
                            
                            user.saveInBackgroundWithBlock({ (success, error) -> Void in
                                if success {
                                    print("saved geopoint")
                                }
                            })
                        
                    } else {
                        print("error: \(error)")
                    }
                 })

                var pictureData: NSData = UIImagePNGRepresentation(profilePic)!
                while pictureData.length > 5000000 {
                    
                    pictureData = UIImageJPEGRepresentation(profilePic, 0.5)!
                }
                
                let imageFile = PFFile(data: pictureData)
                imageFile?.saveInBackgroundWithBlock({ (success, error) -> Void in
                    print("image file saved")
                })
                            
                
                user.profilePic = imageFile!
                
                
                user.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success {
                        print("Saved!!")
                        
                        let successAlert = UIAlertController(title: "Success", message: "Profile was successfully uploaded", preferredStyle: UIAlertControllerStyle.Alert)
                        successAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(successAlert, animated: true, completion: nil)
                        
                        
                        
                    } else {
                        print("Error: \(error)")
                        print("Error: \(error)")
                        let errorAlert = UIAlertController(title: "Error", message: "Error updating profile", preferredStyle: UIAlertControllerStyle.Alert)
                        errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(errorAlert, animated: true, completion: nil)
                        
                        
                    }
                })
                
        } else {
            // error
        }
        
        
    }

    
    @IBAction func uploadPhotoButtonPressed(sender: UIButton) {
    }
    
    @IBAction func profilePicButtonPressed(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    //MARK: General Methods
    
    func configureTextView() {
        
        let myGrey = UIColor(colorLiteralRed: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1)
        
        aboutArtistTextView.layer.cornerRadius = 5.0
        aboutArtistTextView.layer.borderWidth = 1.0
        aboutArtistTextView.layer.borderColor = myGrey.CGColor
        
        aboutArtistTextView.delegate = self
        

    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if aboutArtistTextView.text == tvPlaceholder {
            aboutArtistTextView.text = ""
        }
        
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func configureImageView() {
        
        profilePicToUpload.layer.cornerRadius = profilePicToUpload.frame.size.width/2
        profilePicToUpload.clipsToBounds = true
    }
    
    func fillTextFieldsWithData() {
        let currentUser = LinkedUser.currentUser()
        
        if let currentUser = currentUser {
            artistNameTextField.text = currentUser.name
            shopAddressTextField.text = currentUser.shopAddress
            artistEmailTextField.text = currentUser.contactEmail
            
            if currentUser.aboutArtist != "" {
                aboutArtistTextView.text = currentUser.aboutArtist
            } else {
                aboutArtistTextView.text = tvPlaceholder
            }
        
            currentUser.profilePic.getDataInBackgroundWithBlock{ (data, error) -> Void in
                guard let data = data,
                    let image = UIImage(data: data) else {return}
                    self.profilePicToUpload.image = image
            }
            
        }
        
       
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        for subview in self.view.subviews {
            if subview.isFirstResponder() == true {
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    
                    let keyboardOrigin = view.frame.size.height - keyboardSize.height
                    
                    if subview.frame.origin.y + subview.frame.height > keyboardOrigin {
                       // profilePicTopConstraint
                        print("im hidden")
                        
                        let distanceToMoveConstraint = subview.frame.origin.y - keyboardOrigin + subview.frame.height + 10
                        profilePicTopConstraint.constant -= distanceToMoveConstraint
                        UIView.animateWithDuration(0.5) { self.view.layoutIfNeeded()}
                        print(distanceToMoveConstraint)
                        
                    }
                }
            }
        }
      
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        if profilePicTopConstraint.constant != originalTopConstraint {
            profilePicTopConstraint.constant = originalTopConstraint
            UIView.animateWithDuration(0.5) { self.view.layoutIfNeeded()}
            
        }
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePicToUpload.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}
