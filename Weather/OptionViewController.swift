//
//  OptionViewController.swift
//  Weather CF
//
//  Created by Bruno Lima Martins on 5/19/15.
//  Copyright (c) 2015 Bruno Lima. All rights reserved.
//

import Foundation
import UIKit


class OptionViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
                self.navigationController?.topViewController.title = "Options"
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: Selector("doneButtonPressed:"))
        
       
        self.navigationItem.leftBarButtonItem = doneButton
        if(defaults.objectForKey("type")==nil){
            defaults.setObject(1 as Int?, forKey:"type")
            defaults.synchronize()
        }

        if(defaults.objectForKey("type") as! Int==2){
            segmentedControl.selectedSegmentIndex = 1
        }else{
                segmentedControl.selectedSegmentIndex = 0
        }
        segmentedControl.addTarget(self, action: "changeFormat:", forControlEvents: .ValueChanged)
        twitterButton.addTarget(self, action: "twitterLinkPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        let attributedString = NSMutableAttributedString(string: " ")
        let textAttachment = NSTextAttachment()
//        textAttachment.image = UIImage(named:"twitter")
//        let oldWidth = textAttachment.image!.size.width
//        let scaleFactor = oldWidth / (twitterButton.frame.size.width - 10)
//        textAttachment.image = UIImage(CGImage:textAttachment.image!.CGImage,scale:scaleFactor, orientation:UIImageOrientation.Up)
        let attrStringWithImage = NSAttributedString(attachment:textAttachment)
        
        attributedString.replaceCharactersInRange(NSMakeRange(0, 1), withAttributedString:attrStringWithImage)

        twitterButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
    }
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.bdevapps.WeatherCF")!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func linkPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://github.com/brunolmartins/SimplyWeather")!)
    }
    
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    func changeFormat(sender: UISegmentedControl) {
        segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
        println(sender.selectedSegmentIndex)
                switch sender.selectedSegmentIndex {
                case 0:
                    defaults.setObject(1 as Int?, forKey:"type")
                    defaults.synchronize()

                case 1:
                    defaults.setObject(2 as Int?, forKey:"type")
                    defaults.synchronize()
                default:
                    defaults.setObject(1 as Int?, forKey:"type")
                    defaults.synchronize()
                }
        
    }
    
    func doneButtonPressed(sender:UIBarButtonItem){
        animVIew()
        performSegueWithIdentifier("back", sender: self)
    }
    
    func animVIew(){
        
        let animationDuration = 0.35
        
        
        view.transform = CGAffineTransformScale(view.transform, 0.001, 0.001)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            let v = self.navigationController?.view
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: v!
                , cache: false)
        })
        
    }
    
    
    @IBAction func devbPressed(sender: UIButton) {
         UIApplication.sharedApplication().openURL(NSURL(string:"https://bdevapps.com/apps")!)
    }
    
    

    @IBOutlet var twitterButton: UIButton!
    func twitterLinkPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://twitter.com/sonvphan")!)
    }

    @IBAction func devsPressed(sender: UIButton) {
         UIApplication.sharedApplication().openURL(NSURL(string:"https://github.com/sonphanusa")!)
    }
}