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
    var dvcTatsArray = [Tattoo]()
    
    @IBOutlet weak var tattooDetailImageView: PFImageView!
    @IBOutlet weak var tattooDescriptionlabel: UILabel!
    @IBOutlet weak var viewArtistButton: UIButton!
    
    //MARK: View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tattooDetailImageView.file = tattoo.tattooImage
        tattooDetailImageView.loadInBackground()
        tattooDescriptionlabel.text = tattoo.tattooDescription
        
        let indexOfPreviousVC = (navigationController?.viewControllers.count)!-2
        if indexOfPreviousVC >= 0 {
            if let previousVC = navigationController?.viewControllers[indexOfPreviousVC] {
                if previousVC.isKindOfClass(ArtistProfileCollectionViewController) {
                    viewArtistButton.hidden = true
                }
            }
        }
    }
    
    //MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToArtistProfileCVC" {
            
            let artistFromDVC =  tattoo.tattooArtist
            
            let destinationViewController = segue.destinationViewController as! ArtistProfileCollectionViewController
            
            destinationViewController.artist = artistFromDVC
            
        }

    }
}
