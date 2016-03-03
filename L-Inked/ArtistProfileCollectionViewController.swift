//
//  ArtistProfileCollectionViewController.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-25.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Parse
import FMMosaicLayout
import MapKit
import MessageUI

class ArtistProfileCollectionViewController: UICollectionViewController, FMMosaicLayoutDelegate, MFMailComposeViewControllerDelegate {
    //MARK: Properties

    var artist = LinkedUser()
    var artistPortfolio = [Tattoo]()
    let imageCache = NSCache()
  
    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        
        let mosaicLayout = FMMosaicLayout()
        collectionView!.collectionViewLayout = mosaicLayout;
        
        let currentUser = LinkedUser.currentUser()
        if currentUser != artist {
            navigationItem.rightBarButtonItem = nil
        }

    }

    override func viewWillAppear(animated: Bool) {
        
        
        let query = Tattoo.query()
        query!.whereKey("tattooArtist", equalTo:artist)
        query!.orderByDescending("createdAt")
        query!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            guard let tattoos = objects as? [Tattoo] else {
                return
            }
            self.artistPortfolio = tattoos
            self.collectionView?.reloadData()
    
        }

    }
    
    //MARK: CollectionViewController Delegate
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(artistPortfolio.count)
        
        return artistPortfolio.count
        
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> CustomCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCollectionViewCell
        
        let individual = artistPortfolio[indexPath.row]
        if let objID = individual.objectId,
            let cached = imageCache.objectForKey(objID) as? UIImage {
                
                cell.tattooImageView.image = cached
        } else {
            
            
            cell.tattooImageView.image = nil
            
            individual.tattooImage.getDataInBackgroundWithBlock { (data, error) -> Void in
                
                
                guard let data = data,
                    let image = UIImage(data: data) else { return }
                cell.tattooImageView.image = image
                
                if let objID = individual.objectId {
                    self.imageCache.setObject(image, forKey: objID)
                }
            }
        }
        return cell
    }
    
    //MARK: MosaicLayout Delegate
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, numberOfColumnsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return MosiacConstants.insets
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, interitemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, mosaicCellSizeForItemAtIndexPath indexPath: NSIndexPath! ) -> FMMosaicCellSize {
        return indexPath.item % 7 == 0 ? FMMosaicCellSize.Big : FMMosaicCellSize.Small
    }
    
    //MARK: Reusableview
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    
        let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! ProfileReusableView
        
        supplementaryView.artistNameLabel.text = artist.name
        
        supplementaryView.artistInfoTextView.text = "\(artist.aboutArtist)\r\n" + "\r\n" + "Shop Address: \(artist.shopAddress)"
        
        supplementaryView.artistInfoTextView.setContentOffset(CGPointZero, animated: false)
        


        
        
        artist.profilePic.getDataInBackgroundWithBlock { (data, error) -> Void in
            
            guard let data = data,
                let image = UIImage(data: data) else {return}
            supplementaryView.artistProfilePic.image = image
            supplementaryView.artistProfilePic.layer.cornerRadius = supplementaryView.artistProfilePic.frame.size.width/2
            supplementaryView.artistProfilePic.clipsToBounds = true
            
        }
        return supplementaryView
    }

    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, heightForHeaderInSection section: Int) -> CGFloat {
        
        return view.frame.size.height*0.70
    }
    
    func headerShouldOverlayContentInCollectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!) -> Bool {
        
        return false
    }

    
    //MARK: General functions
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("L-Inked")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }

    
    //MARK: MFMailComposerViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func presentSignInPage(alert: UIAlertAction!) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewControllerWithIdentifier("NavController")
        
        
        self.presentViewController(navController, animated: true) { () -> Void in
            
        }
    }
    
    
    
    //MARK: Actions
    
    @IBAction func messageButtonPressed(sender: UIButton) {
        if let currentUser = LinkedUser.currentUser() {
            let mailComposeViewController = configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Sign In", message: "Please sign in before messaging an artist", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Sign In", style: UIAlertActionStyle.Default, handler: presentSignInPage))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromProfileToDVCSegue" {
            let destinationViewController = segue.destinationViewController as! TattooDetailViewController
            
            if let cell = sender as? CustomCollectionViewCell, indexPath = collectionView?.indexPathForCell(cell) {
                
              
                destinationViewController.tattoo = artistPortfolio[indexPath.row]
                
                
            }
        }
        else if segue.identifier == "showMapFromArtist" {
            
            let zoomLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(artist.shopGeopoint.latitude, artist.shopGeopoint.longitude)
            
            let destinationViewController = segue.destinationViewController as! MapViewController
            
            destinationViewController.zoomLocation = zoomLocation
        }
    }
    
    

}


