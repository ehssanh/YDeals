//
//  PickAirportViewController.swift
//  YDeals
//
//  Created by msndev on 2019-05-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit
import MapKit

class PickAirportViewController: OnboardingSequenceElement, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    var locationManager : LocationHelper?
    var yDealsGatewaysParser =  YDealsGatewaysParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = LocationHelper(parentViewController: self);
        self.map.delegate = self;
        self.askForUserLocation();
        
        self.showUIBusy();
        
        self.yDealsGatewaysParser.parse { (gateways, parseError) in
            
            guard let gateways = gateways, parseError == nil else {
                //TODO: default airport : Toronto
                self.hideUIBusy();
                return;
            }
            
            // initialize now
            self.addAirportAnnotationPoints(gateways: gateways);
            self.hideUIBusy();
        }
    }
    
    func addAirportAnnotationPoints(gateways: [YDealsGateway]) -> Void{

        let supportedAirports = gateways.filter { (gateway) -> Bool in
            return gateway.enabled;
        }
        
        for airport in supportedAirports{
            self.locationManager?.getLocation(forPlaceCalled: airport.airportAddress, placeFound: { (location) in

                guard let location = location else{
                    return;
                }

                let annotation = MKAirportAnnotation()
                annotation.coordinate = location.coordinate;
                annotation.title = airport.cityName + "(" + airport.gateway + ")";
                annotation.airportData = airport
                
                DispatchQueue.main.async {
                    self.map.addAnnotation(annotation);
                }
            })
        }
    }
    
    func showPlacesOnMap(_ places : [MKPlacemark]){
        DispatchQueue.main.async {
            self.map.addAnnotations(places);
        }
    }
    
    func askForUserLocation() -> Void{
        self.locationManager?.getUserLocation(completion: { (location, locErr) in
            
            if let err = locErr {
                Utilities.showLog(err.localizedDescription, parent: self)
                //Utilities.showError(err.localizedDescription, parent: self)
            }
            
            guard let userLoation = location else{
                Utilities.showError("Cant find user location", parent: self)
                return;
            }            
            
            DispatchQueue.main.async {
                let coordinate2d = CLLocationCoordinate2D(latitude: userLoation.coordinate.latitude, longitude: userLoation.coordinate.longitude);
                let mapRegion = MKCoordinateRegion(center: coordinate2d, latitudinalMeters: MAP_ZOOM_DIAMETER_METERS, longitudinalMeters: MAP_ZOOM_DIAMETER_METERS)
                
                self.map.showsUserLocation = true;
                self.map.userLocation.title = nil;
                
                self.locationManager?.convertLatLongToAddressInCountry(latitude: coordinate2d.latitude, longitude: coordinate2d.longitude, countryFound: { (countryName) in
                    if "canada" == countryName.lowercased() {
                        self.map.setRegion(mapRegion, animated: true);
                    }else{
                        //Default to YYZ if Person outside Canada
                        toast("Looks like you are outside Canada. Defaulting to Toronto (YYZ) Airport. Feel free to change it!", size: .small, duration: .normal)
                        let yyzCoordinate = CLLocationCoordinate2D(latitude: 43.6777, longitude: -79.6248);
                        let yyzRegion = MKCoordinateRegion(center: yyzCoordinate, latitudinalMeters: MAP_ZOOM_DIAMETER_METERS, longitudinalMeters: MAP_ZOOM_DIAMETER_METERS)
                        self.map.setRegion(yyzRegion, animated: true);
                    }
                })
                
                
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotationView = view;
        guard let annotation = annotationView.annotation , annotation is MKAirportAnnotation  else {
            mapView.deselectAnnotation(annotationView.annotation, animated: false);
            return;
        }
        
        let airportAnnotation = annotationView.annotation as! MKAirportAnnotation
        let title = airportAnnotation.title!
        print(title)
        
        let airport = airportAnnotation.airportData
        Persistence.save(value:airport , key: PERSISTENCE_KEY_CURRENT_YDEALS_GATEWAY)
        self.navigateToNext(withData: airportAnnotation.airportData);
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        for view in views{
            if view.annotation?.isKind(of: MKAirportAnnotation.self) ?? false {
                view.isAccessibilityElement = true;
                view.accessibilityIdentifier = "YYZ";
            }
        }
    }
    
}

