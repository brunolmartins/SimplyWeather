//
//  WeatherService.swift
//  Weather
//
//  Created by Joyce Echessa on 10/16/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//
//  Changes and features to be added by Son Phan on 04/27/15
//  Open-source on Github.com/sonphanusa

import Foundation

class WeatherService {
    
    typealias WeatherDataCompletionBlock = (data: WeatherData?, error: NSError?) -> ()
    
    let session: NSURLSession
    
    class var sharedInstance: WeatherService {
        struct Singleton {
            static let instance = WeatherService()
        }
        return Singleton.instance
    }
    
    init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration)
    }
    
    func fetchWeatherData(latLong: String, completion: WeatherDataCompletionBlock) {
        
        let apiKey = "YOURAPIKEY"
        
        if(apiKey=="YOURAPIKEY"){
            NSLog("\n**********\nInsert APIKEY:\nWeatherDataKit>WeatherData>WeatherService\nhttps://developer.forecast.io/register\n**********")
        }
        
        let baseUrl = NSURL(string: "https://api.forecast.io/forecast/"+apiKey+"/\(latLong)")
        let request = NSURLRequest(URL: baseUrl!)
        let task = session.dataTaskWithRequest(request) {[unowned self] data, response, error in
            if error == nil {
                var jsonError: NSError?
                if (jsonError == nil) {
                    if let weatherDictionary = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments, error: &jsonError) as? NSDictionary{
                        self.defaults.setObject(weatherDictionary, forKey:"weatherDictionary")
                        self.defaults.synchronize()
                        let data = WeatherData(weatherDictionary: weatherDictionary)
                        completion(data: data, error: nil)
                    }} else {
                    completion(data: nil, error: jsonError)
                }
            } else {
                if(self.defaults.objectForKey("weatherDictionary")==nil){
                    completion(data: nil, error: error)
                }
                else{
                    let weatherDictionary = self.defaults.objectForKey("weatherDictionary") as! NSDictionary
                    let data = WeatherData(weatherDictionary: weatherDictionary)
                    completion(data: data, error: nil)
                }
                
            }
        }
        
        task.resume()
    }
    
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.bdevapps.WeatherCF")!
}


