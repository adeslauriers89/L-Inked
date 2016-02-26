//
//  AppDelegate.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-22.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        
        Tattoo.registerSubclass()
        LinkedUser.registerSubclass()
        Parse.setApplicationId(APIKeys.parseAppID, clientKey: APIKeys.parseClientKey)
        
        
        return true
    }



}

