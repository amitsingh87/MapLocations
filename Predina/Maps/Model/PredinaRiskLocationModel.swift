//
//  RiskLocationModel.swift
//  Predina
//
//  Created by Amit Singh on 26/07/18.
//  Copyright © 2018 Amit Singh. All rights reserved.
//

import Foundation
import MapKit

class PredinaRiskLocationModel: NSObject,MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var riskLocationColor:String?
    
    init(lat:String, lng:String, color:String?) {
        let latDouble = Double(lat)
        let lngDouble = Double(lng)
        self.coordinate = CLLocationCoordinate2D(latitude: latDouble!, longitude: lngDouble!)
        self.riskLocationColor = color
        
        super.init()
    }
}
