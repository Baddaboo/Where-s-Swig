//
//  ViewController.swift
//  Where's Swig
//
//  Created by David Blake Tsuzaki on 2/27/16.
//  Copyright © 2016 Modoki. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    @IBOutlet weak var pointerImageView: UIImageView!
    var swigLoc: CLLocationCoordinate2D!
    var locationManager: CLLocationManager!
    var degrees: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        swigLoc = CLLocationCoordinate2D(latitude: 37.347211, longitude: -121.940386)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == .AuthorizedAlways{
            self.startManager(locationManager)
        }
    }
    
    func startManager(manager: CLLocationManager){
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse{
            self.startManager(manager)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let currentLoc = newLocation.coordinate
        let delLon = swigLoc.longitude-currentLoc.longitude
        var deg = atan2(sin(delLon) * cos(swigLoc.latitude), cos(currentLoc.latitude) * sin(swigLoc.latitude) - sin(currentLoc.latitude) * cos(swigLoc.latitude) * cos(delLon)) * (180 / M_PI);
        
        if(deg < 0){
            deg = -deg;
        } else {
            deg = 360 - deg;
        }
        degrees = CGFloat(deg);
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        pointerImageView.transform = CGAffineTransformMakeRotation(10+CGFloat(degrees-CGFloat(newHeading.trueHeading)*CGFloat(M_PI))/180.0)
    }
}

