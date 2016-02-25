//
//  Tattoo.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-23.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse

class Tattoo: PFObject, PFSubclassing {
    
    @NSManaged var tattooArtist: PFUser
    @NSManaged var tattooDescription: String
    @NSManaged var tattooImage: PFFile
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Tattoo"
    }
}




