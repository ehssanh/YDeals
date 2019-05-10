//
//  PickAirportViewController.swift
//  YDeals
//
//  Created by msndev on 2019-05-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PickAirportViewController: BaseViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.locationManager.requestWhenInUseAuthorization();
        self.locationManager.startUpdatingLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription);
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.description);
    }



}
