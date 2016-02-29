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

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var profilePicToUpload: UIImageView!
    @IBOutlet weak var artistNameTextField: UITextField!
    @IBOutlet weak var shopAddressTextField: UITextField!
    @IBOutlet weak var artistEmailTextField: UITextField!
    @IBOutlet weak var aboutArtistTextView: UITextView!
    
    var geoCoder = CLGeocoder()
    var shopGeopoint = PFGeoPoint()
    
    
    
    //MARK: View controller life cycle
    
    override func viewDidLoad() {
        
    configureTextView()
    
    fillTextFieldsWithData()

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
                
                // user.setObject(name, forKey: "Name")
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
                        
                        
                    } else {
                        print("Error: \(error)")
                    }
                })
                
        } else {
            // error
        }
        
        
    }
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        
        LinkedUser.logOut()
        print("logged out")
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
        
        //aboutArtistTextView.text = "Tel"
        
//        if aboutArtistTextView.text == nil {
//            
//        }
       
    }
    
    func fillTextFieldsWithData() {
        let currentUser = LinkedUser.currentUser()
        
        if let currentUser = currentUser {
            artistNameTextField.text = currentUser.name
            shopAddressTextField.text = currentUser.shopAddress
            artistEmailTextField.text = currentUser.contactEmail
            aboutArtistTextView.text = currentUser.aboutArtist
            
            currentUser.profilePic.getDataInBackgroundWithBlock{ (data, error) -> Void in
                guard let data = data,
                    let image = UIImage(data: data) else {return}
                    self.profilePicToUpload.image = image
            }
            
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
