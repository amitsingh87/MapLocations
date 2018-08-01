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
    
    let regionRadius: CLLocationDistance = 200000
    var predinaRiskLocationViewModel = PredinaRiskLocationViewModel()
    var mapLocations:[PredinaRiskLocationModel] = [PredinaRiskLocationModel] ()
    
    var currentPageCount:Int = 0
    var locationsPlotted:Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        predinaRiskLocationViewModel.mapRefreshDelegate = self
        
        pouplateMap()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func pouplateMap (){
        let centreLocation = CLLocation(latitude: 52.897724, longitude: -1.313197)
        centerMapOnLocation(location: centreLocation)
        
        predinaRiskLocationViewModel.getRiskLocations(pageSize: "100000", currentPage: "1")
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
        
        if let locations = mapLocations{
            mapView.addAnnotations(locations)
            locationsPlotted = Int32(locations.count)
        }
        
        if locationsPlotted < totalLocations {
            // Keep invoking the api unless we have all the locations plotted
            self.predinaRiskLocationViewModel.getRiskLocations(pageSize: "100000", currentPage: String(currentPageCount+1))
        } else {
            // After getting all the data start the pagination again to get the updated data set
            currentPageCount = 0
            predinaRiskLocationViewModel.getRiskLocations(pageSize: "100000", currentPage: "1")
        }
    }
}

