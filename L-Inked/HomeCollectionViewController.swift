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
    
    var artistsArray = [PFObject]()
    
    
    //MARK: View controller life cycle
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        let mosaicLayout = FMMosaicLayout()
        collectionView!.collectionViewLayout = mosaicLayout;
    }
    
    override func viewWillAppear(animated: Bool) {

        let query = Tattoo.query()
        query?.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            guard let tattoos = objects as? [Tattoo] else {
                return
            }
            self.tattoosArray = tattoos
            self.collectionView?.reloadData()
           // print(self.tattoosArray)

            }
        
        let currentUser = PFUser.currentUser()
            if currentUser == nil  || currentUser!["isArtist"].boolValue == false  {
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
        } else {
            print("Youre an artist! ")
            
        }
        /////////////////////////////////////
        /////////
        ///// FETCH TATTOOS FOR SPECIFIC ARTIST
        
        
        
        
//        let queryArtists = PFQuery(className:"Tattoo")
//        queryArtists.whereKey("tattooArtist", equalTo:currentUser!)
//        queryArtists.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) tattoos.")
//                // Do something with the found objects
//                if let objects = objects {
//                    for object in objects {
//                        print(object.objectId)
//                    }
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }

        //////
        /////////////////////////////////////////
    }
    
    //MARK: CollectionVC Delegate
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tattoosArray.count
 
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> CustomCollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCollectionViewCell
        cell.tattooImageView.image = nil
        
       let individual = tattoosArray[indexPath.row]
        
        individual.tattooImage.getDataInBackgroundWithBlock { (data, error) -> Void in

            guard let data = data,
                let image = UIImage(data: data) else { return }
            cell.tattooImageView.image = image

            
        }
        return cell
    }
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "tattooDetailViewControllerSegue" {
            let destinationViewController = segue.destinationViewController as! TattooDetailViewController
            if let cell = sender as? CustomCollectionViewCell, indexPath = collectionView?.indexPathForCell(cell) {
                
                destinationViewController.tattoo = tattoosArray[indexPath.row]
            }
       
   
            
            
        }
        

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
