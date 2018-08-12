//
//  MapRiskLocationUtil.swift
//  Predina
//
//  Created by Amit Singh on 26/07/18.
//  Copyright © 2018 Amit Singh. All rights reserved.
//

import Foundation
import UIKit

class PredinaRiskMapUtil{
    
    static let shared = PredinaRiskMapUtil()
    
    private init() {}
    
    func locationColor(riskColor:String?) -> UIColor? {
        
        guard let color = riskColor else{
            return UIColor.clear
        }
        
        switch color
        {
        case "9","10":
            return UIColor(red: 139, green: 0, blue: 0, alpha: 1.0)//DarkRed
        case "8":
            return UIColor.red
        case "6","7":
            return UIColor.orange
        case "4","5":
            return UIColor.yellow
        case "1","2","3":
            return UIColor.green
        default:
            return UIColor.black
        }
    }
    
    
    
    
}

