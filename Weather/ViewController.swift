//
//  ViewController.swift
//  Weather CF
//
//  Created by Bruno Lima Martins on 5/5/15.
//  Copyright (c) 2015 Bruno Lima. All rights reserved.
//

import UIKit
import WeatherDataKit
import CoreLocation

class ViewController: WeatherDataViewController, CLLocationManagerDelegate, UIScrollViewDelegate{
    
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.bdevapps.WeatherCF")!
    var latLong = "41.3887242,-82.0722262"
    let locationManager = CLLocationManager()
    let locations  = ["name": "My Location", "latLong": ""]
    var dict = Dictionary<Int, [String:String]>()
    
    @IBAction func poweredButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://forecast.io/")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dict.removeAll(keepCapacity: false)
        view.backgroundColor = UIColor(hue:0.58, saturation:0.92, brightness:0.84, alpha:1)
        feelslikeLabel.text = "--"
        summaryLabel.text = "--"
        timeLabel.text = "--"
        humidityLabel.text = "--"
        precipitationLabel.text = "--"
        temperatureLabel.text =  "--"
        windspeedLabel.text =  "--"
        temperatureMinLabel.text =  "--"
        temperatureMaxLabel.text =  "--"
        locationLabel.text =  "--"
        if(defaults.objectForKey("type")==nil){
            defaults.setObject(1 as Int?, forKey:"type")
            defaults.synchronize()
        }
        var title = "Fº"
        if(defaults.objectForKey("type") as! Int==2){
            title = "Cº"
        }
        
        
        let button1 = UIBarButtonItem(title: "Options", style: .Plain, target: self, action: Selector("optionsButtonPressed:"))
        let refresh = UIBarButtonItem(title: "refresh", style: .Plain, target: self, action: Selector("refresh"))
        //        refresh.image = UIImage(named:"refresh")
        //        button1.image = UIImage(named:"options")
        let button2 = UIBarButtonItem(title: "Locations", style: .Plain, target: self, action: Selector("locationsButtonPressed"))
        
        if let font = UIFont(name: "Avenir-Black", size: 18) {
            button2.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        self.navigationItem.rightBarButtonItems = [button1,refresh]
        self.navigationItem.leftBarButtonItem = button2
        self.navigationController?.topViewController.title = "Weather Lite"
        
    }
    
    func refresh(){
        let locationData = defaults.objectForKey("locationData") as! [String:String]
        if("\(locationData.0)" == "[latLong: , name: My Location]"){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else{
            let locationDict: NSDictionary? = defaults.objectForKey("locationData") as? NSDictionary
            if let dictionary = locationDict {
                locationLabel.text = dictionary["name"] as? String
                latLong = dictionary["latLong"] as! String
            }
            getWeatherData(latLong, completion: { (error) -> () in
                if error == nil {
                    self.updateData()
                }
            })
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            println("info")
            if (error != nil) {
                NSLog("Error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let placem = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(placem)
            } else {
                NSLog("Placemarks = 0")
            }
        })
    }
    func displayLocationInfo(placemark: CLPlacemark) {
        
        if (placemark.name==nil) {
        }
            
        else{
            locationManager.stopUpdatingLocation()
            println(placemark.location.coordinate.latitude)
            println(placemark.location.coordinate.longitude)
            latLong = String(stringInterpolationSegment: placemark.location.coordinate.latitude)+","+String(stringInterpolationSegment: placemark.location.coordinate.longitude)
            
            getWeatherData(latLong, completion: { (error) -> () in
                if error == nil {
                    println(placemark.locality)
                    self.locationLabel.text = placemark.locality
                    self.updateData()
                }
            })
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(defaults.objectForKey("locationData")==nil){
            defaults.setObject(locations, forKey:"locationData")
            defaults.synchronize()
            dict[0] = locations.0
            let dataSave = NSKeyedArchiver.archivedDataWithRootObject(dict)
            defaults.setObject(dataSave, forKey:"locationList")
            defaults.synchronize()
        }
        
        
        let locationData = defaults.objectForKey("locationData") as! [String:String]
        if("\(locationData.0)" == "[latLong: , name: My Location]"){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else{
            let locationDict: NSDictionary? = defaults.objectForKey("locationData") as? NSDictionary
            if let dictionary = locationDict {
                locationLabel.text = dictionary["name"] as? String
                latLong = dictionary["latLong"] as! String
            }
            getWeatherData(latLong, completion: { (error) -> () in
                if error == nil {
                    self.updateData()
                }
            })
            
        }
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            scrollView.frame = CGRectMake(scrollView.frame.origin.x,300, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-300)
        }else{
            scrollView.frame = CGRectMake(scrollView.frame.origin.x,250, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-250)}
        
    }
    override func viewDidLayoutSubviews() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            scrollView.frame = CGRectMake(scrollView.frame.origin.x,300, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-300)
        }else{
            scrollView.frame = CGRectMake(scrollView.frame.origin.x,250, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-250)
        }
    }
    
    func optionsButtonPressed(sender:UIBarButtonItem){
        
        performSegueWithIdentifier("options", sender: self)
        
    }
    
    
    func locationsButtonPressed(){
        performSegueWithIdentifier("locations", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "locations"){
            let animationDuration = 0.35
            
            
            view.transform = CGAffineTransformScale(view.transform, 0.001, 0.001)
            
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
                let v = self.navigationController?.view
                UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: v!
                    , cache: false)
            })
            
        }
        else{
            animVIew()}
    }
    
    func animVIew(){
        
        let animationDuration = 0.35
        
        
        view.transform = CGAffineTransformScale(view.transform, 0.001, 0.001)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            let v = self.navigationController?.view
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: v!
                , cache: false)
        })
        
    }
}

