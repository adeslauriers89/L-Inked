//
//  HomeCollectionViewController.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-23.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import FMMosaicLayout
import Parse


class HomeCollectionViewController: UICollectionViewController, FMMosaicLayoutDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    //MARK: View controller life cycle
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        let mosaicLayout = FMMosaicLayout()
        collectionView!.collectionViewLayout = mosaicLayout;
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let currentUser = PFUser.currentUser()
        
        print("\(currentUser)")
        
        if currentUser == nil  || currentUser!["isArtist"].boolValue == false  {
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
        } else {
            print("Youre an aritist! :P")
            
        }

    }
    
    //MARK: CollectionVC Delegate
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.redColor()
        
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
  
}
