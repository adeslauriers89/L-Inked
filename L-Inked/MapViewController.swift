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



class MyLocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    
    func askForPermission() {
        if (locationManager.respondsToSelector("requestWhenInUseAuthorization")) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    }
    
}

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    //MARK: Properties
    
    let locationManager = MyLocationManager()
    var shopLocations = [String]()
    let zoomArea = 5000
    var geoCoder = CLGeocoder()
    var zoomLocation = CLLocationCoordinate2D()
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: ViewController Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        
        initiateMap()

    }
    
    override func viewDidLoad() {
        locationManager.askForPermission()
    }
    
    //MARK: General Methods
    
    func initiateMap() {
        
        let currentUser = LinkedUser.currentUser()
        
        if currentUser != nil {
         //   let currentLocation = locationManager.locationManager.location
//            let zoomLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake((currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!)
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
            
            
          
            let directionsBtn = UIButton(type: .DetailDisclosure)
            directionsBtn.setImage(UIImage(named: "car"), forState: UIControlState.Normal)
            
            annotationView?.leftCalloutAccessoryView = directionsBtn

            
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
            
        } else if control == view.leftCalloutAccessoryView {
            mapView.removeOverlays(mapView.overlays)
            
          
            if let annoatation = view.annotation {
                getDirections(annoatation)
            }
        }
    }
    //////////////////////////
    
    func getDirections(annotation: MKAnnotation) {
        
        let placemark = MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        
        let request = MKDirectionsRequest()
        request.source = (MKMapItem.mapItemForCurrentLocation())
        request.destination = mapItem
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            if error !=  nil {
                print("Error getting directions")
            } else {
                self.showRoute(response!)
            }
            
        }
    }
    
    func showRoute(response: MKDirectionsResponse) {
        
        for route in response.routes {
            mapView.addOverlay(route.polyline,
                level: MKOverlayLevel.AboveRoads)
            
            for step in route.steps {
                print(step.instructions)
            }
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 5.0
            return renderer
    }
    
    /////////
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProfileFromMap" {
            
            let artistFromMap = sender as! LinkedUser
            let destinationViewController = segue.destinationViewController as! ArtistProfileCollectionViewController
            destinationViewController.artist = artistFromMap
        }
    
    }

}
