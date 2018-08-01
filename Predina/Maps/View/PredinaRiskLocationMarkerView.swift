//
//  PredinaRiskLocationMarkerView.swift
//  Predina
//
//  Created by Amit Singh on 26/07/18.
//  Copyright © 2018 Amit Singh. All rights reserved.
//

import Foundation
import MapKit

class PredinaRiskLocationMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            
            guard let riskLocationModel = newValue as? PredinaRiskLocationModel else { return }
            
            markerTintColor = PredinaRiskMapUtil.shared.locationColor(riskColor: riskLocationModel.riskLocationColor)
        }
    }
}
