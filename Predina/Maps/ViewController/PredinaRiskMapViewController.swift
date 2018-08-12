//
//  ViewController.swift
//  Predina
//
//  Created by Amit Singh on 25/07/18.
//  Copyright © 2018 Amit Singh. All rights reserved.
//

import UIKit
import MapKit

class PredinaRiskMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let regionRadius: CLLocationDistance = 300000
    var predinaRiskLocationViewModel = PredinaRiskLocationViewModel()
    var mapLocations:[PredinaRiskLocationModel] = [PredinaRiskLocationModel] ()
    
    var currentPageCount:Int = 0
    var locationsPlotted:Int32 = 0
    
    let locationManager = CLLocationManager()
    
    let firstLoadPageSize = "0"
    let updatePageSize = "100000"
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        predinaRiskLocationViewModel.mapRefreshDelegate = self
        
        //checkLocationAuthorizationStatus()
        
        activityIndicator.frame = view.bounds
        
        pouplateMap()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func pouplateMap (){
        let centreLocation = CLLocation(latitude: 55.986615, longitude: -3.800686)
        centerMapOnLocation(location: centreLocation)
        
        // Show loading indicator to User
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        predinaRiskLocationViewModel.getRiskLocations(pageSize: firstLoadPageSize, currentPage: "1")
    }
}

extension PredinaRiskMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? PredinaRiskLocationModel else { return nil }
        
        let identifier = "locationMarker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.markerTintColor = PredinaRiskMapUtil.shared.locationColor(riskColor: annotation.riskLocationColor)
        }
        return view
        
    }
    
}

extension PredinaRiskMapViewController:RefreshLocationListener{
    
    func refreshMapWithLocations(mapLocations: [PredinaRiskLocationModel]?, totalLocations: Int32) {
        
        DispatchQueue.main.async {
            //Stop the indicator
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            
            if let locations = mapLocations{
                if self.mapView.annotations.count > 0{
                    self.mapView.removeAnnotations(self.mapView.annotations)
                }
                
                self.mapView.addAnnotations(locations)
                self.locationsPlotted = Int32(locations.count)
            }
        }

        let delayTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.predinaRiskLocationViewModel.updateRiskLocations()
        }
        /*
        
        let delayTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            if self.locationsPlotted < totalLocations {
                // Keep invoking the api unless we have all the locations plotted
                self.predinaRiskLocationViewModel.getRiskLocations(pageSize: "1000", currentPage: String(self.currentPageCount+1))
            } else {
                // After getting all the data start the pagination again to get the updated data set
                self.currentPageCount = 0
                self.predinaRiskLocationViewModel.getRiskLocations(pageSize: "1000", currentPage: "1")
            }
        }*/
        
    }
    
    func locationsUpdated() {
        self.predinaRiskLocationViewModel.getRiskLocations(pageSize: updatePageSize, currentPage: "1")
    }
}

