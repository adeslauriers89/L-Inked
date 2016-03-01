//
//  LoginSignupViewController.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-22.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse
import AVFoundation
import AVKit


class LoginSignupViewController: UIViewController, LoginViewDelegate, SignupViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    var loginViewScreen: LoginView?
    var signupViewScreen: SignupView?
    var player: AVPlayer?
    
    // MARK: View life cycle
    
    override func viewWillAppear(animated: Bool) {
     
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidLoad() {
        ///////////////////
        super.viewDidLoad()
        
        // Load the video from the app bundle.
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("sample", withExtension: ".mp4")!
        
        player = AVPlayer(URL: videoURL)
        player?.actionAtItemEnd = .None
        player?.muted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
       // playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        
        contentView.layer.addSublayer(playerLayer)
       // view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "loopVideo",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: nil)
    
        
        

        //////

    }

    
    //MARK: Actions

    @IBAction func loginButtonPressed(sender: UIButton) {
        
        loginViewScreen?.removeFromSuperview()
        signupViewScreen?.removeFromSuperview()
        
        loginViewScreen = NSBundle.mainBundle().loadNibNamed("LoginView", owner: self, options: nil).first as? LoginView
        if let loginViewScreen = loginViewScreen {
            contentView.addSubview(loginViewScreen)
            addConstraintsToLogin()
            loginViewScreen.delegate = self
        }
    }
    
    @IBAction func signupButtonPressed(sender: UIButton) {
        
        loginViewScreen?.removeFromSuperview()
        signupViewScreen?.removeFromSuperview()
        
        signupViewScreen = NSBundle.mainBundle().loadNibNamed("SignupView", owner: self, options: nil).first as? SignupView
       
        if let signupViewScreen = signupViewScreen {
            contentView.addSubview(signupViewScreen)
            addConstraintsToSignup()
            signupViewScreen.delegate = self
        }
    }

    func login(username: String, password: String) {
        LinkedUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
            if  (user != nil) {
                print("logged in")
                self.performSegueWithIdentifier("showMainViewControllerSegue", sender: self)
            } else {
                print("ERROR")
            }
        })
        
        

    }
    
    func signup(username: String, password: String, email: String, isArtist: Bool) {
        
        let newUser = LinkedUser()
        newUser.username = username
        newUser.password = password
        newUser.email = email
        newUser.setObject(isArtist, forKey: "isArtist")

        
        
        
        newUser.signUpInBackgroundWithBlock { (success, error) -> Void in
            if success {
                print("Created new user")
                self.performSegueWithIdentifier("showMainViewControllerSegue", sender: self)
            } else {
                print("Error")
            }
            
        }

    }

    func addConstraintsToSignup() {
        signupViewScreen!.translatesAutoresizingMaskIntoConstraints = false

        let xCenterConstraint = NSLayoutConstraint(item: signupViewScreen!, attribute: .CenterX, relatedBy: .Equal , toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0)
        contentView.addConstraint(xCenterConstraint)
        
        let heightContstraint = NSLayoutConstraint(item: signupViewScreen!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 250)
        contentView.addConstraint(heightContstraint)
        
        let widthContstraint = NSLayoutConstraint(item: signupViewScreen!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 250)
        contentView.addConstraint(widthContstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: signupViewScreen!, attribute: .CenterY, relatedBy: .Equal , toItem: contentView, attribute: .CenterY, multiplier: 1, constant: -50)
        contentView.addConstraint(yCenterConstraint)
    }
    
    func addConstraintsToLogin() {
        loginViewScreen!.translatesAutoresizingMaskIntoConstraints = false
        
        let xCenterConstraint = NSLayoutConstraint(item: loginViewScreen!, attribute: .CenterX, relatedBy: .Equal , toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0)
        contentView.addConstraint(xCenterConstraint)
        
        let heightContstraint = NSLayoutConstraint(item: loginViewScreen!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 250)
        contentView.addConstraint(heightContstraint)
        
        let widthContstraint = NSLayoutConstraint(item: loginViewScreen!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 250)
        contentView.addConstraint(widthContstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: loginViewScreen!, attribute: .CenterY, relatedBy: .Equal , toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0)
        contentView.addConstraint(yCenterConstraint)

    }
    
   //////
    func loopVideo() {
        player?.seekToTime(kCMTimeZero)
        player?.play()
    }
    
    
}
