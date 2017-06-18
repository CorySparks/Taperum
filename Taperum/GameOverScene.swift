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

struct Constants{
    static let adColonyAppID = "app2d48ffc3e2404f278f"
    static let adColonyZoneID = "vzeffe8de1c8ce4102a8"
}

class GameOverScene: SKScene {
    
    var score: Int = 0
    var gold: Int = 0
    var characterIndex: Int!
    
    var scoreLabel: SKLabelNode!
    var goldLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!
    var newGameBtnNode: SKSpriteNode!
    var menuBtnNode: SKSpriteNode!
    var twitterLogo: SKSpriteNode!
    var facebookLogo: SKSpriteNode!
    
    var userDefaults = UserDefaults.standard
    
    var totalGold = UserDefaults.standard.integer(forKey: "totalGold")
    
    override func didMove(to view: SKView) {
        //####VUNGLE####
        var appID = "5942ea1625cbbb8e4f002a70"
        //var sdk = VungleSDK.sharedSDK()
        // start vungle publisher library
        //sdk.startWithAppId(appID)
        //####END VUNGLE####
        
        
        //####ADCOLONY####
        /*AdColony.configure(withAppID: Constants.adColonyAppID, zoneIDs: [Constants.adColonyZoneID], options: nil,
                           completion:{(zones) in
                            
                            //AdColony has finished configuring, so let's request an interstitial ad
                            self.requestInterstitial()
                            
                            //If the application has been inactive for a while, our ad might have expired so let's add a check for a nil ad object
                            NotificationCenter.default.addObserver(self, selector:#selector(ViewController.onBecameActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
            }
        )*/
        //####END ADCOLONY####
        
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
    
    //####ADCOLONY####
    /*func requestInterstitial(){
        //Request an interstitial ad from AdColony
        AdColony.requestInterstitial(inZone: Constants.adColonyZoneID, options:nil,
                                     
                                     //Handler for successful ad requests
            success:{(newAd) in
                
                //Once the ad has finished, set the loading state and request a new interstitial
                newAd.setClose({
                    self.ad = nil
                    
                    self.setLoadingState()
                    self.requestInterstitial()
                })
                
                //Interstitials can expire, so we need to handle that event also
                newAd.setExpire({
                    self.ad = nil
                    
                    self.setLoadingState()
                    self.requestInterstitial()
                })
                
                //Store a reference to the returned interstitial object
                self.ad = newAd
                
                //Show the user we are ready to play a video
                self.setReadyState()
        },
            
            //Handler for failed ad requests
            failure:{(error) in
                NSLog("SAMPLE_APP: Request failed with error: " + error.localizedDescription + " and suggestion: " + error.localizedRecoverySuggestion!)
        }
        )
    }
    
    func launchInterstitial(_ sender: AnyObject){
        //Display our ad to the user
        if let ad = self.ad {
            if (!ad.expired) {
                ad.show(withPresenting: self)
            }
        }
    }
    
    func onBecameActive(){
        //If our ad has expired, request a new interstitial
        if (self.ad == nil) {
            self.requestInterstitial()
        }
    }*/
    //####END ADCOLONY####
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodeArray = self.nodes(at: location)
            
            if(nodeArray.first?.name == "newGameBtn"){
                let transition = SKTransition.fade(withDuration: 1.0)
                if let gameScene = GameScene(fileNamed: "GameScene"){
                    gameScene.scaleMode = .aspectFill
                    gameScene.characterIndex = self.characterIndex
                    gameScene.totalGold = self.totalGold + self.gold
                    
                    self.view?.presentScene(gameScene, transition: transition)
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
            
            if(nodeArray.first?.name == "menuBtn"){
                let transition = SKTransition.fade(withDuration: 1.0)
                if let menuScene = MenuScene(fileNamed: "MenuScene"){
                    menuScene.scaleMode = .aspectFill
                    
                    self.view?.presentScene(menuScene, transition: transition)
                }
                
            }
        }
    }
    
}
