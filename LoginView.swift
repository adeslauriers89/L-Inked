//
//  LoginView.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-22.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse

protocol LoginViewDelegate: class {
    
    func login(username: String, password: String)
}



class LoginView: UIView {
    
    //MARK: Properties

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var delegate: LoginViewDelegate?
    
    //MARK: Actions
    
    
    

    
    @IBAction func loginSubmitButtonPressed(sender: UIButton) {
        
        if let username = usernameTextField.text,
            password = passwordTextField.text {
                
                delegate?.login(username, password: password)
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
