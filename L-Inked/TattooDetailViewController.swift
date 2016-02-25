//
//  TattooDetailViewController.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-24.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class TattooDetailViewController: UIViewController {
    
    //MARK: Properties
    
    var tattoo = Tattoo()
    @IBOutlet weak var tattooDetailImageView: PFImageView!
    
    //MARK: View controller life cycle
    
    override func viewDidLoad() {
        
        print("HELLO ADAM\(tattoo)")
        
        
        
        
        tattooDetailImageView.file = tattoo.tattooImage
        tattooDetailImageView.loadInBackground()
        
        
        
    }
    
    
}
