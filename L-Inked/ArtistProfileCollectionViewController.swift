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

class ArtistProfileCollectionViewController: UICollectionViewController, FMMosaicLayoutDelegate {
    //MARK: Properties

    var artist = LinkedUser()
    var artistPortfolio = [Tattoo]()
  
    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        
        let mosaicLayout = FMMosaicLayout()
        collectionView!.collectionViewLayout = mosaicLayout;
        
        print(artist.aboutArtist)

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
        
//        print(artistPortfolio.count)
        
        return artistPortfolio.count
        
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> CustomCollectionViewCell {
     
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCollectionViewCell
        let individual = artistPortfolio[indexPath.row]
        
        individual.tattooImage.getDataInBackgroundWithBlock { (data, error) -> Void in
            
            
            guard let data = data,
                let image = UIImage(data: data) else { return }
            cell.tattooImageView.image = image
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
        
        supplementaryView.aboutArtistLabel.text = artist.aboutArtist
//        supplementaryView.aboutArtistLabel.sizeToFit()
//        supplementaryView.aboutArtistLabel.lineBreakMode = .ByWordWrapping
        
        
        
  
        
        supplementaryView.shopAddressLabel.text = "Shop Address: \(artist.shopAddress)"
//        supplementaryView.shopAddressLabel.sizeToFit()
//        supplementaryView.aboutArtistLabel.lineBreakMode = .ByWordWrapping
        
        
        artist.profilePic.getDataInBackgroundWithBlock { (data, error) -> Void in
            guard let data = data,
                let image = UIImage(data: data) else {return}
             supplementaryView.artistProfilePic.image = image
        }
        return supplementaryView
    }

    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, heightForHeaderInSection section: Int) -> CGFloat {
        
        return view.frame.size.height*0.75
    }
    
    func headerShouldOverlayContentInCollectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!) -> Bool {
        
        return false
    }
    
    //MARK: General functions
    

}


    

//struct MosiacConstants {
//    static let insets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
//}
