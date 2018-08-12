//
//  PredinaRiskLocationViewModel.swift
//  Predina
//
//  Created by Amit Singh on 26/07/18.
//  Copyright © 2018 Amit Singh. All rights reserved.
//

import Foundation

protocol RefreshLocationListener {
    func refreshMapWithLocations(mapLocations:[PredinaRiskLocationModel]?, totalLocations:Int32)
    func locationsUpdated()
}

class PredinaRiskLocationViewModel {
    
    let kDefaultPageSize:String = "100000"
    let kDefaultCurrentPage:String = "1"
    
    var mapRefreshDelegate:RefreshLocationListener?
    
    func getRiskLocations(pageSize:String?, currentPage:String?){
        let service = PredinaRequestLocationService()
        service.delegate = self
        service.fetchLocations(pageSize: pageSize ?? kDefaultPageSize, currentPage: kDefaultCurrentPage)
    }
    
    func updateRiskLocations(){
        let service = PredinaRequestLocationService()
        service.delegate = self
        service.updateLocations()
    }
}

extension PredinaRiskLocationViewModel:ServiceLisener{
    func didUpdateLocations() {
        self.mapRefreshDelegate?.locationsUpdated()
    }
    
    func didFailWithError(error: Error?) {
        
    }
    
    func didRecieveResponse(response: [String : Any]) {
        guard let _ = self.mapRefreshDelegate else {return}
        
        let locations:[[String:String]] = response["risklocations"] as! [[String : String]]
        var mapLocations:[PredinaRiskLocationModel] = [PredinaRiskLocationModel] ()
        
        let totalCount:Int32 = response["totalItems"] as! Int32
        
        for riskLocation:[String:String] in locations{
            let latitude = riskLocation["latitude"]
            let longitude = riskLocation["longitude"]
            let color = riskLocation["riskcolor"]
            let model:PredinaRiskLocationModel = PredinaRiskLocationModel(lat: latitude!, lng:longitude!, color: color)
            mapLocations.append(model)
        }
        self.mapRefreshDelegate?.refreshMapWithLocations(mapLocations: mapLocations, totalLocations:totalCount)
    }
}
