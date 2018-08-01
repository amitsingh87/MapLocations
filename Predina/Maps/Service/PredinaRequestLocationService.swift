//
//  PredinaRequestLocationService.swift
//  Predina
//
//  Created by Amit Singh on 30/07/18.
//  Copyright © 2018 Amit Singh. All rights reserved.
//

import Foundation

protocol ServiceLisener {
    func didRecieveResponse(response:[String:Any]) -> Void;
    func didFailWithError(error:Error?) -> Void;
}
class PredinaRequestLocationService: NSObject {
    
    var delegate:ServiceLisener?
    
    func fetchLocations(pageSize:String?, currentPage:String?) -> Void {
        
        var inputParams = [String:String]()
        
        if let _ = pageSize{
            inputParams["pageSize"] = pageSize
        }
        
        if let _ = currentPage{
            inputParams["currentPage"] = currentPage
        }
        
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: inputParams, options: .prettyPrinted)
            
            let url = NSURL(string: "http://localhost/predina")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error)  in
                
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    
                    if let _ = self.delegate{
                        self.delegate?.didRecieveResponse(response: result)
                    }
                } catch {
                    print("Error -> \(error)")
                    if let _ = self.delegate{
                        self.delegate?.didFailWithError(error: error)
                    }
                }
            }
            task.resume()
            
            
        } catch {
            print(error)
        }
        
    }
    
}
