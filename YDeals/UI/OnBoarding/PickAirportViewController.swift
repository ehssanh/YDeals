//
//  PickAirportViewController.swift
//  YDeals
//
//  Created by msndev on 2019-05-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit
import MapKit

class PickAirportViewController: BaseViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    var locationManager : LocationHelper?
    var parser =  YDealsGatewaysParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = LocationHelper(parentViewController: self);
        self.map.delegate = self;
        self.askForUserLocation();
        
        self.showUIBusy();
        
        parser.parse { (gateways, parseError) in
            
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
                annotation.title = airport.cityName;
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
                Utilities.showError(err.localizedDescription, parent: self)
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
                self.map.setRegion(mapRegion, animated: true);
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotationView = view;
        let airportAnnotation = annotationView.annotation as! MKAirportAnnotation
        let title = airportAnnotation.title!
        print(title)
        
        let main = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! ViewController
        main.setYDealsGateway(airportAnnotation.airportData!)
        self.navigationController?.pushViewController(main, animated: true);
        
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationIdentifier = "AirportAnnotationIdentifier"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//            annotationView!.canShowCallout = true
//        }
//        else {
//            annotationView!.annotation = annotation
//        }
//
//        //let pinImage = UIImage(named: "customPinImage")
//        //annotationView!.image = pinImage
//
//        return annotationView;
//    }
    

}

