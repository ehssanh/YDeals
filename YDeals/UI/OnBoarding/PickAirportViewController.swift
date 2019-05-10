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
    
    
    let airports = [
        "YXX Airport, Abbotsford ,BC, Canada",
        "YYC Airport, Calgary ,AB, Canada",
        "YYG Airport, Charlottetown, PE, Canada",
        "YQQ Airport, Comox, BC, Canada",
        "YDF Airport, Deer Lake, NL, Canada",
        "YEG Airport, Edmonton, AB, Canada",
        "YMM Airport, Fort McMurray, AB, Canada",
        "YQU Airport, Grande Prairie, AB, Canada",
        "YHZ Airport, Halifax, NS, Canada",
        "YHM Airport, Hamilton, ON, Canada",
        "YKA Airport, Kamloops, BC, Canada",
        "YLW Airport, Kelowna, BC, Canada",
        "YXU Airport, London, ON, Canada",
        "YQM Airport, Moncton, NB, Canada",
        "YUL Airport, Montreal, QC, Canada",
        "YOW Airport, Ottawa, ON, Canada",
        "YXS Airport, Prince George, BC, Canada",
        "YQB Airport, Quebec City, QC, Canada",
        "YQR Airport, Regina, SK, Canada",
        "YSJ Airport, Saint John, NB, Canada",
        "YXE Airport, Saskatoon, SK, Canada",
        "YYT Airport, St. John's, NL, Canada",
        "YQT Airport, Thunder Bay, ON, Canada",
        "YYZ Airport, Toronto, ON, Canada",
        "YVR Airport, Vancouver international Airport, BC, Canada",
        "YYJ Airport, Victoria, BC, Canada",
        "YWG Airport, Winnipeg, MB, Canada"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = LocationHelper(parentViewController: self);
        self.map.delegate = self;
        
        addAirportAnnotationPoints();
        askForUserLocation();

    }
    
    func addAirportAnnotationPoints() -> Void{

        for airportAddress in self.airports{
            self.locationManager?.getLocation(forPlaceCalled: airportAddress, placeFound: { (location) in
                
                guard let location = location else{
                    return;
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate;
                annotation.title = String(airportAddress.split(separator: ",", maxSplits: 4, omittingEmptySubsequences: true).first!)
                self.map.addAnnotation(annotation);
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
                return;
            }
            
            
            let coordinate2d = CLLocationCoordinate2D(latitude: userLoation.coordinate.latitude, longitude: userLoation.coordinate.longitude);
            let mapRegion = MKCoordinateRegion(center: coordinate2d, latitudinalMeters: MAP_ZOOM_DIAMETER_METERS, longitudinalMeters: MAP_ZOOM_DIAMETER_METERS)
            
            
            DispatchQueue.main.async {
                self.map.showsUserLocation = true;
                self.map.userLocation.title = nil;
                self.map.setRegion(mapRegion, animated: true);
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotationView = view;
        let title = annotationView.annotation?.title!
        if title != nil {
            print(title!)
        }
        
        let main = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController();
        self.navigationController?.pushViewController(main!, animated: true);
        
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

