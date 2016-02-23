//
//  SignupView.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-22.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse

protocol SignupViewDelegate: class {
    
    func signup(username: String, password: String, email: String, isArtist: Bool)

}

class SignupView: UIView {
    
    //MARK: Properties:
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var paswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var isArtistSwitch: UISwitch!
    
    weak var delegate: SignupViewDelegate?
    
    //MARK: Actions
   
    @IBAction func signupSubmitButtonPressed(sender: UIButton) {
        
    if let username = usernameTextField.text,
           password = paswordTextField.text,
           email = emailTextField.text {
        
            let isArtist = isArtistSwitch.on
        delegate?.signup(username, password: password, email: email, isArtist: isArtist)
        }
    }
    

    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
