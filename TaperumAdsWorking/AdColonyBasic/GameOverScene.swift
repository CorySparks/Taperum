//
//  GameOver.swift
//  Taperum
//
//  Created by Cory Sparks on 5/23/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import SpriteKit
import Social
import UIKit
import Foundation
import GoogleMobileAds
import AudioToolbox

class GameOverScene: SKScene, GADBannerViewDelegate, VungleSDKDelegate{
    
    var score: Int = 0
    var gold: Int = 0
    var characterIndex: Int!
    var canPlay = true
    
    var scoreLabel: SKLabelNode!
    var goldLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!
    var newGameBtnNode: SKSpriteNode!
    var menuBtnNode: SKSpriteNode!
    var twitterLogo: SKSpriteNode!
    var facebookLogo: SKSpriteNode!
    
    var ad: AdColonyInterstitial?
    var adMobBannerView = GADBannerView()
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-5505401440099083/2665210456"
    var PlayAdNew = UserDefaults.standard.integer(forKey: "PlayAd") + 1
    
    var userDefaults = UserDefaults.standard
    
    var totalGold = UserDefaults.standard.integer(forKey: "totalGold")
    
    override func didMove(to view: SKView) {
        initAdMobBanner()
        requestInterstitial()
        adViewDidReceiveAd(adMobBannerView)
        
        self.scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "Score: \(score)"
        
        self.goldLabel = self.childNode(withName: "goldLabel") as! SKLabelNode
        goldLabel.text = "Earned: \(gold)"
        
        let menuScene = MenuScene(fileNamed: "MenuScene")
        let bestScore = menuScene?.bestScore
        var newBest = bestScore
        if(score > (bestScore)!){
            newBest = score
            userDefaults.set(score, forKey: "Best")
            userDefaults.synchronize()
        }
        
        self.bestScoreLabel = self.childNode(withName: "bestScoreLabel") as! SKLabelNode
        bestScoreLabel.text = "Best: \((newBest)!)"
        
        self.newGameBtnNode = self.childNode(withName: "newGameBtn") as! SKSpriteNode
        self.menuBtnNode = self.childNode(withName: "menuBtn") as! SKSpriteNode
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func playAd(){
        if self.PlayAdNew >= 6 {
            self.userDefaults.set(0, forKey: "PlayAd")
            self.userDefaults.synchronize()
            self.PlayAdNew = 0
            if let ad = self.ad {
                if (!ad.expired) {
                    ad.show(withPresenting: (self.view?.window?.rootViewController)!)
                }else if VungleSDK.shared().isAdPlayable(){
                    playVungleAd(sender: "5942ea1625cbbb8e4f002a70" as AnyObject)
                }else{
                    canPlay = true
                }
            }
            hideBanner(adMobBannerView)
            canPlay = true
        }else{
            self.userDefaults.set(self.PlayAdNew, forKey: "PlayAd")
            self.userDefaults.synchronize()
            canPlay = true
        }
    }
    
    func playVungleAd(sender: AnyObject) {
        let sdk = VungleSDK.shared()
        sdk?.delegate = self
        do {
            try sdk?.playAd(self.view?.window?.rootViewController, withOptions: nil)
        }catch{
            print(error)
        }
    }
        
    
    func requestInterstitial(){
        //Request an interstitial ad from AdColony
        AdColony.requestInterstitial(inZone: "vzeffe8de1c8ce4102a8", options:nil,
                                     
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
                
                
                self.playAd()
                
        },
            
            //Handler for failed ad requests
            failure:{(error) in
                NSLog("SAMPLE_APP: Request failed with error: " + error.localizedDescription + " and suggestion: " + error.localizedRecoverySuggestion!)
        }
        )
    }
    
    func initAdMobBanner() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
            adMobBannerView.frame = CGRect(x: 0, y: (view?.frame.size.height)!, width: 320, height: 50)
        } else  {
            // iPad
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 468, height: 60))
            adMobBannerView.frame = CGRect(x: 0, y: (view?.frame.size.height)!, width: 468, height: 60)
        }
        
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self.view?.window?.rootViewController
        adMobBannerView.delegate = self
        view?.addSubview(adMobBannerView)
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        if PlayAdNew < 6{
            adMobBannerView.load(request)
        }
    }
    
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        banner.frame = CGRect(x: (view?.frame.size.width)!/2 - banner.frame.size.width/2, y: (view?.frame.size.height)! - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: (view?.frame.size.width)!/2 - banner.frame.size.width/2, y: (view?.frame.size.height)! - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        hideBanner(adMobBannerView)
    }
    
    func onBecameActive(){
        //If our ad has expired, request a new interstitial
        if (self.ad == nil) {
            self.requestInterstitial()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodeArray = self.nodes(at: location)
            
            if canPlay{
                if(nodeArray.first?.name == "newGameBtn"){
                    let transition = SKTransition.fade(withDuration: 1.0)
                    if let gameScene = GameScene(fileNamed: "GameScene"){
                        gameScene.scaleMode = .aspectFill
                        gameScene.characterIndex = self.characterIndex
                        gameScene.totalGold = self.totalGold + self.gold
                        hideBanner(adMobBannerView)
                        adMobBannerView.removeFromSuperview()
                        
                        self.view?.presentScene(gameScene, transition: transition)
                    }
                }
                
                if(nodeArray.first?.name == "menuBtn"){
                    let transition = SKTransition.fade(withDuration: 1.0)
                    if let menuScene = MenuScene(fileNamed: "MenuScene"){
                        menuScene.scaleMode = .aspectFill
                        hideBanner(adMobBannerView)
                        adMobBannerView.removeFromSuperview()
                        
                        self.view?.presentScene(menuScene, transition: transition)
                    }
                    
                }
            }
            
            if(nodeArray.first?.name == "facebook"){
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                    let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    
                    self.view?.window?.rootViewController?.present(fbShare, animated: true, completion: nil)
                    
                } else {
                    let alert = UIAlertController(title: "Accounts", message: "It looks like you do not have the Facebook app, download the app and share your score with friends!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
            
            if(nodeArray.first?.name == "twitter"){
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                    
                    let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    
                    self.view?.window?.rootViewController?.present(tweetShare, animated: true, completion: nil)
                    
                } else {
                    
                    let alert = UIAlertController(title: "Accounts", message: "It looks like you do not have the Twitter app, download the app and share your score with friends!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
