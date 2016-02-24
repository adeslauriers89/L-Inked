//
//  EditProfileViewController.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-23.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var profilePicToUpload: UIImageView!
    @IBOutlet weak var artistNameTextField: UITextField!
    @IBOutlet weak var shopAddressTextField: UITextField!
    @IBOutlet weak var artistEmailTextField: UITextField!
    @IBOutlet weak var aboutArtistTextView: UITextView!
    
    
    
    //MARK: View controller life cycle
    
    override func viewDidLoad() {
        
    configureTextView()


    }
    
    
    //MARK: Actions
    
    @IBAction func saveProfileButtonPressed(sender: UIButton) {
        let user =  PFUser.currentUser()
        
        if let user = user,
            name = artistNameTextField.text,
            contactEmail = artistEmailTextField.text,
            address = shopAddressTextField.text,
            about = aboutArtistTextView.text,
            profilePic = profilePicToUpload.image {
                
                // user.setObject(name, forKey: "Name")
                user["Name"] = name
                user.setObject(contactEmail, forKey: "ContactEmail")
                user.setObject(address, forKey: "ShopAddress")
                user.setObject(about, forKey: "AboutArtist")
                
                
                var pictureData: NSData = UIImagePNGRepresentation(profilePic)!
                while pictureData.length > 500000 {
                    
                    pictureData = UIImageJPEGRepresentation(profilePic, 0.5)!
                }
                
                let imageFile = PFFile(name: "image.png", data: pictureData)
                
                
                
                user.setObject(imageFile!, forKey: "ProfilePic")
                
                
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
        
        PFUser.logOut()
        print("logged out")
    }
    
    @IBAction func uploadPhotoButtonPressed(sender: UIButton) {
    }
    
    
    
    //MARK: General Methods
    
    func configureTextView() {
        
        let myGrey = UIColor(colorLiteralRed: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1)
        
        aboutArtistTextView.layer.cornerRadius = 5.0
        aboutArtistTextView.layer.borderWidth = 1.0
        aboutArtistTextView.layer.borderColor = myGrey.CGColor
//        aboutArtistTextView.attributedText = NSAttributedString(string: "Hey", attributes: [NSForegroundColorAttributeName: myGrey])
//        
    }

}
