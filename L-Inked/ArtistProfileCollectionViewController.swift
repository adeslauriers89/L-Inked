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

class ArtistProfileCollectionViewController: UICollectionViewController, FMMosaicLayoutDelegate {
    
    
    //MARK: Properties
    
    @IBOutlet weak var profileView: ProfileReusableView!
    
    
    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        
        
//        collectionView?.registerClass(UICollectionReusableView(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")

        
        let mosaicLayout = FMMosaicLayout()
        collectionView!.collectionViewLayout = mosaicLayout;
    }
    
    
    //MARK: CollectionViewController Delegate
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 8
        
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> CustomCollectionViewCell {
     
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCollectionViewCell
        
        return cell
        }
    
    //MARK: MosaicLayout Delegate
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, numberOfColumnsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
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
        
        return supplementaryView
    }
    
   
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 400.0
    }


    func headerShouldOverlayContentInCollectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!) -> Bool {
        
        return false
    }



    
    }

    
    

