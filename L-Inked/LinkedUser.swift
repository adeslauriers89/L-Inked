//
//  LinkedUser.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-25.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse

class LinkedUser: PFUser {
    
    @NSManaged var name: String
    @NSManaged var aboutArtist: String
    @NSManaged var isArtist: Bool
    @NSManaged var shopAddress: String
    @NSManaged var profilePic: PFFile
    @NSManaged var contactEmail: String
    
    @NSManaged var tattoos: [Tattoo]
    
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    

}
