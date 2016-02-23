//
//  EditProfileViewController.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-23.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var profilePicToUpload: UIImageView!
    @IBOutlet weak var artistNameTextField: UITextField!
    @IBOutlet weak var shopAddressTextField: UITextField!
    @IBOutlet weak var artistEmailTextField: UITextField!
    @IBOutlet weak var aboutArtistTextView: UITextView!
    
    
    
    //MARK: View controller life cycle
    
    override func viewDidLoad() {
        
        aboutArtistTextView.layer.cornerRadius = 5.0
        aboutArtistTextView.layer.borderWidth = 1.0
        aboutArtistTextView.layer.borderColor = UIColor(colorLiteralRed: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1).CGColor


    }
    
    
    //MARK: Actions
    
    @IBAction func saveProfileButtonPressed(sender: UIButton) {
    }
    
    @IBAction func uploadPhotoButtonPressed(sender: UIButton) {
    }

}
