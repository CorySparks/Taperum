//
//  ViewController.swift
//  AdColonyBasic
//
//  Copyright (c) 2016 AdColony. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit
import StoreKit
import GameKit

struct Constants{
    static let adColonyAppID = "app2d48ffc3e2404f278f"
    static let adColonyZoneID = "vzeffe8de1c8ce4102a8"
    
    static let currencyBalance = "CurrencyBalance"
    static let currencyBalanceChange = "CurrencyBalanceChange"
}


class ViewController: UIViewController{

    var ad: AdColonyInterstitial?
    var userDefaults = UserDefaults.standard
    let totalGold = UserDefaults.standard.integer(forKey: "totalGold")
    
    //=============================================
    // MARK:- UIViewController Overrides
    //=============================================
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Configure AdColony once
        AdColony.configure(withAppID: Constants.adColonyAppID, zoneIDs: ["vz59dd9c0d4b5b4c369e", "vzeffe8de1c8ce4102a8"], options: nil,
            completion:{(zones) in
                
                let zone = zones.first
                zone?.setReward({(success, name, amount) in
                    if (success) {
                        //Get currency balance from persistent storage and update it
                        
                    }
                })
                
                //AdColony has finished configuring, so let's request an interstitial ad
                self.requestInterstitialReward()
                self.requestInterstitial()
                
                //If the application has been inactive for a while, our ad might have expired so let's add a check for a nil ad object
                NotificationCenter.default.addObserver(self, selector:#selector(ViewController.onBecameActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
            }
        )
        
        let appID = "5942ea1625cbbb8e4f002a70"
        let sdk = VungleSDK.shared()
        sdk?.start(withAppId: appID)
        
        //Show the user that we are currently loading videos
        //self.setLoadingState()
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return UIStatusBarStyle.lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.all
    }
    
    override var shouldAutorotate: Bool
    {
        return true
    }
    
    
    //=============================================
    // MARK:- AdColony
    //=============================================
    
    func requestInterstitial(){
        //Request an interstitial ad from AdColony
        AdColony.requestInterstitial(inZone: Constants.adColonyZoneID, options:nil,
                                     
            //Handler for successful ad requests
            success:{(newAd) in
                
                //Once the ad has finished, set the loading state and request a new interstitial
                newAd.setClose({
                    self.ad = nil
                    
                    self.requestInterstitial()
                })
                
                //Interstitials can expire, so we need to handle that event also
                newAd.setExpire({
                    self.ad = nil
                    
                    self.requestInterstitial()
                })
                
                //Store a reference to the returned interstitial object
                self.ad = newAd
            },
            
            //Handler for failed ad requests
            failure:{(error) in
                NSLog("SAMPLE_APP: Request failed with error: " + error.localizedDescription + " and suggestion: " + error.localizedRecoverySuggestion!)
            }
        )
        
    }
    
    func requestInterstitialReward(){
        //Request an interstitial ad from AdColony
        AdColony.requestInterstitial(inZone: "vz59dd9c0d4b5b4c369e", options:nil,
                                     
                                     //Handler for successful ad requests
            success:{(newAd) in
                
                //Once the ad has finished, set the loading state and request a new interstitial
                newAd.setClose({
                    self.ad = nil
                    
                    self.requestInterstitial()
                })
                
                //Interstitials can expire, so we need to handle that event also
                newAd.setExpire({
                    self.ad = nil
                    
                    self.requestInterstitial()
                })
                
                //Store a reference to the returned interstitial object
                self.ad = newAd
        },
            
            //Handler for failed ad requests
            failure:{(error) in
                NSLog("SAMPLE_APP: Request failed with error: " + error.localizedDescription + " and suggestion: " + error.localizedRecoverySuggestion!)
        }
        )
        
    }
    
    
    //=============================================
    // MARK:- Event Handlers
    //=============================================

    func onBecameActive(){
        //If our ad has expired, request a new interstitial
        if (self.ad == nil) {
            self.requestInterstitial()
        }
    }
}
