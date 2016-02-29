//
//  ArtistAnnotation.swift
//  L-Inked
//
//  Created by Adam DesLauriers on 2016-02-27.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import MapKit

class ArtistAnnotation: MKPointAnnotation {
    
    var artist: LinkedUser!

}

/*
override func viewWillAppear(animated: Bool) {
    initiateMap()
    self.view.sendSubviewToBack(mapView)
}

override func viewDidLoad() {
    super.viewDidLoad()
    
    if (locationManager.respondsToSelector("requestWhenInUseAuthorization")) {
        locationManager.requestWhenInUseAuthorization()
    }
    
    if (CLLocationManager.locationServicesEnabled()) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
}
func initiateMap() {
    
    let currentUser = User.currentUser()
    if (currentUser != nil) {
        let currentLocation = locationManager.location
        let zoomLocation: CLLocationCoordinate2D =  CLLocationCoordinate2DMake((currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!)
        let adjustedRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, CLLocationDistance(zoomingArea), CLLocationDistance(zoomingArea))

        mapView.setRegion(adjustedRegion, animated: true)
        mapView.showsUserLocation = true
        getVideos()
    }
}

func getVideos() {
    var videos = [Video]()
    let query = PFQuery(className: "Video")
    query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
        if error == nil {
            for object in objects! {
                videos.append(object as! Video)
            }
            self.addVideosToMap(videos)
        } else {
            print(error)
        }
    }
}

func addVideosToMap(videos:[Video]) {
    for video in videos {
        let point: PFGeoPoint = video.location!
        let annotation = VideoAnnotation()
        annotation.video = video
        annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.mapView.addAnnotation(annotation)
        })
    }
}
*/
