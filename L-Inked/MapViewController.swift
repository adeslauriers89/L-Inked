//
//  MapViewController.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-27.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    //MARK: Properties
    
  //  var artistsArray = [LinkedUser]()
    var shopLocations = [String]()
    var locationManager = CLLocationManager()
    let zoomArea = 5000
    var geoCoder = CLGeocoder()
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: ViewController Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        
        initiateMap()

    }
    
    override func viewDidLoad() {
        if (locationManager.respondsToSelector("requestWhenInUseAuthorization")) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    //MARK: General Methods
    
    func initiateMap() {
        
        let currentUser = LinkedUser.currentUser()
        
        if currentUser != nil {
            let currentLocation = locationManager.location
            let zoomLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake((currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!)
            let adjustedRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, CLLocationDistance(zoomArea), CLLocationDistance(zoomArea))
            mapView.setRegion(adjustedRegion, animated: true)
            mapView.showsUserLocation = true
            mapView.delegate = self
            
            getArtists()
            
        }
        
    }
    
    func getArtists() {
        
        var artists = [LinkedUser]()
        let artistQuery = LinkedUser.query()
        artistQuery?.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            guard let users = objects as? [LinkedUser] else {
                return
            }
            for user in users {
                if user.shopAddress != "" {
                    artists.append(user)
                }
               
            }
             self.addArtistsToMap(artists)
        }

    }
    
    func addArtistsToMap(artists:[LinkedUser]) {
        
        for artist in artists {
            let point: PFGeoPoint = artist.shopGeopoint
            let annotation = ArtistAnnotation()
            annotation.artist = artist
            annotation.title = artist.name
           
            annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.mapView.addAnnotation(annotation)
            
            })
    }
    
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) {
            return nil
        }
        let reuseID = "AnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            
            annotationView?.enabled = true
            annotationView!.canShowCallout = true
            
            annotationView!.pinTintColor = UIColor.blueColor()
            let detailsBtn =  UIButton(type: .DetailDisclosure)
            annotationView?.rightCalloutAccessoryView = detailsBtn

            
        }
        else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
        
            if let artistAnnotation = view.annotation as? ArtistAnnotation {
              let selectedArtist = artistAnnotation.artist
            self.performSegueWithIdentifier("showProfileFromMap", sender: selectedArtist)
            }
            
        }
    }
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProfileFromMap" {
            
            let artistFromMap = sender as! LinkedUser
            let destinationViewController = segue.destinationViewController as! ArtistProfileCollectionViewController
            destinationViewController.artist = artistFromMap
        }
    
    }

}
