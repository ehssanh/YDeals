//
//  LocationHelper.swift
//  YDeals
//
//  Created by msndev on 2019-05-10.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationHelper : NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var completioBlock : ((CLLocation?,Error?) -> Void)?
    private weak var parentViewController:UIViewController?
    
    init(parentViewController:UIViewController?) {
        super.init()
        self.parentViewController = parentViewController;
    }

    func getUserLocation(completion:@escaping (_ location:CLLocation?, _ error:Error?) -> Void){
        
        DispatchQueue.global().async {
            if (CLLocationManager.locationServicesEnabled()){
                self.locationManager.delegate = self;
                self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
                
                self.completioBlock = completion
                
                switch CLLocationManager.authorizationStatus(){
                case .notDetermined:
                    self.locationManager.requestWhenInUseAuthorization();
                case .denied ,.restricted:
                    Utilities.showError("Location permission denied", parent: self.parentViewController);
                case .authorizedAlways, .authorizedWhenInUse:
                    self.locationManager.startUpdatingLocation();
                @unknown default:
                    print();
                }
            }else{
                self.completioBlock?(nil, NSError(domain: "Location Permission Error", code: 1, userInfo: nil))
            }
        }
    }
    
    func stopLocationUpdates() -> Void {
        self.locationManager.stopUpdatingLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation();
        }
    }
    
    func getLocation(forPlaceCalled name: String,
                          placeFound: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder();
        geocoder.geocodeAddressString(name) { (placemarks, geoCodeError) in
            
            if geoCodeError != nil {
                placeFound(nil);
                return;
            }
            
            guard let placemark = placemarks?[0] else {
                placeFound(nil)
                return
            }
            
            guard let location = placemark.location else {
                placeFound(nil)
                return
            }
            
            placeFound(location);
        }
    }
    
    
    //MARK: -
    //MARK: CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.completioBlock?(nil, error);
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLoation = locations.last else{
            return;
        }
        
        self.completioBlock?(userLoation, nil);
        self.stopLocationUpdates();
    }
}
