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
    var tattoosArray = [Tattoo]()
    
    let imageCache = NSCache()
  
    //MARK: View controller life cycle
    
    override func viewDidLoad() {
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        let mosaicLayout = FMMosaicLayout()
        collectionView!.collectionViewLayout = mosaicLayout;
    }
    
    override func viewWillAppear(animated: Bool) {

        let query = Tattoo.query()
        query?.includeKey("tattooArtist")
        query?.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            guard let tattoos = objects as? [Tattoo] else {
                return
            }
            self.tattoosArray = tattoos
            self.collectionView?.reloadData()
        }
        
        
        let currentUser = LinkedUser.currentUser()
      
            if currentUser == nil  || currentUser!["isArtist"].boolValue == false  {
            navigationItem.leftBarButtonItem = nil
//            navigationItem.hidesBackButton = true
        } else {
        }
    }
    
    //MARK: CollectionVC Delegate
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tattoosArray.count
 
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> CustomCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCollectionViewCell
        
        let individual = tattoosArray[indexPath.row]
            if let objId = individual.objectId,
            let cached = imageCache.objectForKey(objId) as? UIImage {
            
            cell.tattooImageView.image = cached
        } else {
            
            cell.tattooImageView.image = nil
            
            individual.tattooImage.getDataInBackgroundWithBlock { (data, error) -> Void in
                
                guard let data = data,
                    let image = UIImage(data: data) else { return }
                cell.tattooImageView.image = image
                
                if let objId = individual.objectId {
                    self.imageCache.setObject(image, forKey: objId)
                }
                
            }
        }
        return cell
    }
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "tattooDetailViewControllerSegue" {
            let destinationViewController = segue.destinationViewController as! TattooDetailViewController
            if let cell = sender as? CustomCollectionViewCell, indexPath = collectionView?.indexPathForCell(cell) {
                
                destinationViewController.tattoo = tattoosArray[indexPath.row]
                destinationViewController.dvcTatsArray = tattoosArray
            }
         }
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
}
