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
    
    let locationManager = MyLocationManager()
    
    @IBOutlet weak var orderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    var tattoosArray = [Tattoo]()
    //var tattoosByLocation = [Tattoo]()
    
    let imageCache = NSCache()
  
    //MARK: View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.askForPermission()
        
        
        let mosaicLayout = FMMosaicLayout()
        collectionView!.collectionViewLayout = mosaicLayout;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
      navigationController?.setNavigationBarHidden(false, animated: false)
        getData()
        
        
        
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
        } else if segue.identifier == "segueToMyProfile" {
            let currentUser = LinkedUser.currentUser()
            let artistForProfile = currentUser
            
            let destinationViewController = segue.destinationViewController as! ArtistProfileCollectionViewController
            
            destinationViewController.artist = artistForProfile!
            
        } else if segue.identifier == "showMapSegue" {
            let currentLocation = locationManager.locationManager.location
            
            let zoomLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake((currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!)
            
            let destinationViewController = segue.destinationViewController as! MapViewController
            
            destinationViewController.zoomLocation = zoomLocation
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
    
    //MARK: Actions
    
    @IBAction func logoutToMainViewController(segue:UIStoryboardSegue) {
        LinkedUser.logOut()
        print("logged out")
    }
    
    
    @IBAction func orderControlSelected(sender: UISegmentedControl) {
        getData()
        
    }

    
    //MARK: General Functions
    
    
    func getData() {
        if self.orderSegmentedControl.selectedSegmentIndex == 1 {
            getArtistTattoos()
        } else {
            getTattoos()
        }
    
    }
    
    
    func getArtistTattoos() {
        let query = LinkedUser.query()!
        query.includeKey("tattoos")
        
        if let location = locationManager.locationManager.location {
            if self.orderSegmentedControl.selectedSegmentIndex == 1 {
                
                let geopoint = PFGeoPoint(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude))
                

                query.whereKey("shopGeopoint", nearGeoPoint: geopoint, withinKilometers: 100)
                
            }
        } else {
            // show a dialog bugging them to turn on location services
            
            return
        }
        
        
        let innerQuery = Tattoo.query()!
        
        innerQuery.whereKey("tattooArtist", matchesQuery: query)
        innerQuery.includeKey("tattooArtist")
        
        innerQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            guard let tats = objects as? [Tattoo] else {
                return
            }
            
            self.tattoosArray = tats
            self.collectionView?.reloadData()
            
        }
    }
    
    
    func getTattoos() {
        
        
        let query = Tattoo.query()
        query?.includeKey("tattooArtist")
        query?.orderByDescending("createdAt")
        
        if let location = locationManager.locationManager.location {
            if self.orderSegmentedControl.selectedSegmentIndex == 1 {
                
                let geopoint = PFGeoPoint(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude))
                print("near me selected")
                

                query?.whereKey("tattooArtist.shopGeopoint", nearGeoPoint: geopoint, withinKilometers: 100)
            
            }
        } else {
            // show a dialog bugging them to turn on location services
            
            
            // encapuslate func below, we use it twice
//            
//                    query?.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//            
//                        guard let tattoos = objects as? [Tattoo] else {
//                            return
//                        }
//                        self.tattoosArray = tattoos
//                        self.collectionView?.reloadData()
//                        
//                    }
            
            //return
        }
        
        query?.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            guard let tattoos = objects as? [Tattoo] else {
                return
            }
            self.tattoosArray = tattoos
            self.collectionView?.reloadData()
            
        }
    }
    

    
}
