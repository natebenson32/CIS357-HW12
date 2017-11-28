//
//  WeatherService.swift
//  GeoCalculator
//
//  Created by X Code User on 11/28/17.
//  Copyright © 2017 Jonathan Engelsma. All rights reserved.
//

import Foundation

let sharedDarkSkyInstance = DarkSkyWeatherService()

class DarkSkyWeatherService: WeatherService {
    
    let API_BASE = "https://api.darksky.net/forecast/"
    var urlSession = URLSession.shared
    
    class func getInstance() -> DarkSkyWeatherService {
        return sharedDarkSkyInstance
    }
    
    func getWeatherForDate(date: Date, forLocation location: (Double, Double),
                           completion: @escaping (Weather?) -> Void)
    {
        
        // TODO: concatentate the complete endpoint URL here.
        
        let urlStr = API_BASE + "26c25255dcf84f1d27893492b023ade1/\(location.0),\(location.1)"
        let url = URL(string: urlStr)
        
        let task = self.urlSession.dataTask(with: url!) {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let _ = response {
                let parsedObj : Dictionary<String,AnyObject>!
                do {
                    parsedObj = try JSONSerialization.jsonObject(with: data!, options:
                        .allowFragments) as? Dictionary<String,AnyObject>
                    
                    guard let currently = parsedObj["currently"],
                        let iconName:String = currently["icon"] as? String,
                        let temperature:Double = currently["temperature"] as? Double,
                        let summary:String = currently["summary"] as? String
                    
                    // TODO: extract the attributes you need for a Weather instance HERE
                    
                    else {
                        completion(nil)
                        return
                    }
                    
                    let weather = Weather(iconName: iconName, temperature: temperature,
                                          summary: summary)
                    completion(weather)
                    
                }  catch {
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
}	
