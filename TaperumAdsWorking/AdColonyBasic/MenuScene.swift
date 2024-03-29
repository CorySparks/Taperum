//
//  MenuScene.swift
//  Taperum
//
//  Created by Cory Sparks on 5/23/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import SpriteKit
import UIKit
import StoreKit
import GameKit

struct retardedSquare {
    var name: String
    var design: AnyObject
    var doesNotCost: Bool
    var coins: Int?
}

class MenuScene: SKScene, Alert, GKGameCenterControllerDelegate {
    //This scene is just the start button and the character button
    
    public static let Coin300IAP = "com.com.TheGlassHouseStudios.Taperum.300CoinsTaperum"
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
    let LEADERBOARD_ID = "com.TheGlassHouseStudios.score.Taperum"
    
    var ad: AdColonyInterstitial?
    
    private var base1 : SKShapeNode!
    private var base2 : SKShapeNode!
    private var platform : SKShapeNode!
    private var textBox: SKShapeNode!
    private var textBoxLbl: SKLabelNode!
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var productsResponse = SKProductsResponse()
    var iapProducts = [SKProduct]()
    
    public var baseSize : CGFloat!
    
    var StartBtnNode: SKSpriteNode!
    var AdBtn: SKSpriteNode!
    var CharacterBtnNode: SKSpriteNode!
    var BuyBtnNode: SKSpriteNode!
    var bestscoreLblNode: SKLabelNode!
    var CostLbl: SKLabelNode!
    var totalGoldLabelNode: SKLabelNode!
    var characterName: SKLabelNode!
    var coinImg: SKShapeNode!
    var StoreBtn: SKSpriteNode!
    var canPlay: Bool! = true
    
    var cost: Int! = 0
    
    var userDefaults = UserDefaults.standard
    var bestScore = UserDefaults.standard.integer(forKey: "Best")
    var PlayAd = UserDefaults.standard.integer(forKey: "PlayAd")
    var characterChoice = UserDefaults.standard.integer(forKey: "characterChoice")
    
    var characterArray: [retardedSquare]! = [retardedSquare(name: "white", design: UIColor.white, doesNotCost: true, coins: 0), retardedSquare(name: "blue", design: UIColor.blue, doesNotCost: true, coins: 0), retardedSquare(name: "green", design: UIColor.green, doesNotCost: true, coins: 0), retardedSquare(name: "gray", design: UIColor.gray, doesNotCost: true, coins: 0), retardedSquare(name: "cyan", design: UIColor.cyan, doesNotCost: true, coins: 0), retardedSquare(name: "yellow", design: UIColor.yellow, doesNotCost: true, coins: 0), retardedSquare(name: "red", design: UIColor.red, doesNotCost: true, coins: 0) ,retardedSquare(name: "purple", design: UIColor.purple, doesNotCost: true, coins: 0), retardedSquare(name: "orange", design: UIColor.orange, doesNotCost: true, coins: 0), retardedSquare(name: "brown", design: UIColor.brown, doesNotCost: true, coins: 0), retardedSquare(name: "random", design: SKTexture(image: #imageLiteral(resourceName: "random")), doesNotCost: UserDefaults.standard.bool(forKey: "random"), coins: 50), retardedSquare(name: "mouse", design: SKTexture(image: #imageLiteral(resourceName: "mouse")), doesNotCost: UserDefaults.standard.bool(forKey: "mouse"), coins: 100), retardedSquare(name: "pizza", design: SKTexture(image: #imageLiteral(resourceName: "pizza_mindsunfold")), doesNotCost: UserDefaults.standard.bool(forKey: "pizza"), coins: 100), retardedSquare(name: "yinYang", design: SKTexture(image: #imageLiteral(resourceName: "yinYangTaperum")), doesNotCost: UserDefaults.standard.bool(forKey: "yinYang"), coins: 50), retardedSquare(name: "gaming", design: SKTexture(image: #imageLiteral(resourceName: "Gaming")), doesNotCost: UserDefaults.standard.bool(forKey: "gaming"), coins: 150), retardedSquare(name: "weirdball1", design: SKTexture(image: #imageLiteral(resourceName: "weirdBall1Taperum")), doesNotCost: UserDefaults.standard.bool(forKey: "weirdball1"), coins: 200), retardedSquare(name: "weirdball2", design: SKTexture(image: #imageLiteral(resourceName: "WeirdBall2")), doesNotCost: UserDefaults.standard.bool(forKey: "weirdball2"), coins: 200), retardedSquare(name: "sunglasses", design: SKTexture(image: #imageLiteral(resourceName: "Sunglasses")), doesNotCost: UserDefaults.standard.bool(forKey: "sunglasses"), coins: 150), retardedSquare(name: "football", design: SKTexture(image: #imageLiteral(resourceName: "football")), doesNotCost: UserDefaults.standard.bool(forKey: "football"), coins: 50), retardedSquare(name: "granade", design: SKTexture(image: #imageLiteral(resourceName: "Granade")), doesNotCost: UserDefaults.standard.bool(forKey: "granade"), coins: 150)]
    
    var characterNameVar: Int = 0{
        didSet{
            characterName.text = "\(characterNameVar)"
        }
    }

    
    var characterIndex: Int! = 0

    var totalGold: Int! = 0{
        didSet{
            totalGoldLabelNode.text = "Total Coins: \(String(totalGold))"
        }
    }
    
    override func didMove(to view: SKView) {
        requestInterstitial()
        authenticateLocalPlayer()
        fetchAvailableProducts()
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        characterIndex = characterChoice
        
        self.base1 = self.childNode(withName: "base1") as? SKShapeNode
        self.base2 = self.childNode(withName: "base2") as? SKShapeNode
        self.platform = self.childNode(withName: "BasePlatform") as? SKShapeNode
        
        self.StartBtnNode = self.childNode(withName: "StartBtn") as! SKSpriteNode
        self.CharacterBtnNode = self.childNode(withName: "CharacterBtn") as! SKSpriteNode
        self.BuyBtnNode = SKSpriteNode.init(texture: SKTexture(image: #imageLiteral(resourceName: "BuyBtnTexture")), size: CGSize(width: 150, height: 35))
        self.CostLbl = self.childNode(withName: "CostLbl") as? SKLabelNode
        self.AdBtn = self.childNode(withName: "AdBtn") as! SKSpriteNode
        self.AdBtn.alpha = 0.0
        
        if iapProducts.count > 0{
            self.StoreBtn.name = "StoreBtn"
            self.StoreBtn.position = CGPoint(x: 130, y: -65)
            self.StoreBtn.texture = SKTexture(image: #imageLiteral(resourceName: "StoreLogoTaperum"))
            self.StoreBtn.size = CGSize(width: 45, height: 45)
            addChild(StoreBtn)
        }
        
        baseSize = (self.size.width + self.size.height) * 0.05
        
        self.bestscoreLblNode = SKLabelNode(fontNamed: "Arial")
        self.bestscoreLblNode.text = "Best: \(String(bestScore))"
        self.bestscoreLblNode.horizontalAlignmentMode = .center
        self.bestscoreLblNode.position = CGPoint(x: 0, y: -50)
        addChild(bestscoreLblNode)
        
        addScoreAndSubmitToGC(bestScore as AnyObject)
        
        
        self.totalGoldLabelNode = SKLabelNode(fontNamed: "Arial")
        self.totalGoldLabelNode.fontSize = 25
        self.totalGoldLabelNode.text = "Total Coins: \(String(totalGold))"
        self.totalGoldLabelNode.horizontalAlignmentMode = .center
        self.totalGoldLabelNode.position = CGPoint(x: 0, y: -100)
        addChild(totalGoldLabelNode)
        
        totalGold = UserDefaults.standard.integer(forKey: "totalGold")
        
        self.characterName = SKLabelNode(fontNamed: "Arial")
        self.characterName.fontSize = 25
        self.characterName.text = ""
        self.characterName.horizontalAlignmentMode = .center
        self.characterName.position = CGPoint(x: 0, y: -140)
        characterNameVar = characterIndex
        addChild(characterName)
        
        self.platform = SKShapeNode.init(rectOf: CGSize.init(width: self.size.width, height: (self.size.height / 2) / 2))
        self.base1 = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        self.base2 = SKShapeNode.init(rectOf: CGSize.init(width: baseSize, height: baseSize))
        
        if(!characterArray[characterIndex].doesNotCost){
            if(CostLbl != nil){
                BuyBtnNode.removeFromParent()
                CostLbl.removeFromParent()
            }
            canPlay = false
            
            cost = characterArray[characterIndex].coins
            
            BuyBtnNode.position = CGPoint(x: 120, y: -200)
            BuyBtnNode.texture = SKTexture(image: #imageLiteral(resourceName: "BuyBtnTexture"))
            BuyBtnNode.size = CGSize(width: 150, height: 35)
            BuyBtnNode.name = "BuyBtn"
            
            self.CostLbl = SKLabelNode(fontNamed: "Arial")
            self.CostLbl.text = "Cost: \(cost!)"
            self.CostLbl.horizontalAlignmentMode = .center
            self.CostLbl.position = CGPoint(x: -120, y: -210)
            self.CostLbl.fontSize = 20
            
            addChild(BuyBtnNode)
            addChild(CostLbl)
            
            platform.fillColor = .clear
            platform.strokeColor = .gray
            platform.fillTexture = nil
            
            base1.fillColor = .gray
            base1.strokeColor = .gray
            base1.fillTexture = SKTexture(image: #imageLiteral(resourceName: "questionMark"))
            
            base2.fillColor = .gray
            base2.strokeColor = .gray
            base2.fillTexture = SKTexture(image: #imageLiteral(resourceName: "questionMark"))
        }else{
            canPlay = true
            
            if(CostLbl != nil){
                BuyBtnNode.removeFromParent()
                CostLbl.removeFromParent()
            }
            
            switch characterArray[characterIndex!].design{
                case is UIColor:
                    platform.fillColor = characterArray[characterIndex].design as! UIColor
                    platform.strokeColor = characterArray[characterIndex].design as! UIColor
                    platform.fillTexture = nil
                    
                    base1.fillColor = characterArray[characterIndex].design as! UIColor
                    base1.strokeColor = characterArray[characterIndex].design as! UIColor
                    base1.fillTexture = nil
                    
                    base2.fillColor = characterArray[characterIndex].design as! UIColor
                    base2.strokeColor = characterArray[characterIndex].design as! UIColor
                    base2.fillTexture = nil
                    break
                case is SKTexture:
                    platform.fillColor = .white
                    platform.strokeColor = .clear

                    base1.fillColor = .white
                    base1.strokeColor = .clear
                    base1.fillTexture = characterArray[characterIndex].design as? SKTexture
                    
                    base2.fillColor = .white
                    base2.strokeColor = .clear
                    base2.fillTexture = characterArray[characterIndex].design as? SKTexture
                    break
                default:
                    // hmm
                    break
            }
        }
        
        platform.position.y = (self.size.height / -2)
        base1.position.y = (platform.position.y) / 2 - baseSize - 6
        base2.position.y =  base1.position.y + baseSize
        
        self.addChild(platform)
        self.addChild(base1)
        self.addChild(base2)
        
        if(!launchedBefore){
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            tutorial()
        }
    }
    
    func fetchAvailableProducts()  {
        let productIdentifiers = NSSet(objects:
            "300CoinsTaperum", "1700CoinsTaperum", "4000CoinsTaperum"
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self as? SKProductsRequestDelegate
        productsRequest.start()
        
        print(productsRequest)
    }
    
    func requestInterstitial(){
        //Request an interstitial ad from AdColony
        AdColony.requestInterstitial(inZone: "vz59dd9c0d4b5b4c369e", options:nil,
                                     
                                     //Handler for successful ad requests
            success:{(newAd) in
                
                //Once the ad has finished, set the loading state and request a new interstitial
                newAd.setClose({
                    self.ad = nil
                    self.AdBtn.alpha = 0.0
                    
                    self.requestInterstitial()
                })
                
                //Interstitials can expire, so we need to handle that event also
                newAd.setExpire( {
                    self.ad = nil
                    self.AdBtn.alpha = 0.0
                    
                    self.requestInterstitial()
                })
                
                //Store a reference to the returned interstitial object
                self.AdBtn.alpha = 1.0
                self.totalGold = UserDefaults.standard.integer(forKey: "totalGold")
                self.ad = newAd

                
        },
            
            //Handler for failed ad requests
            failure:{(error) in
                NSLog("SAMPLE_APP: Request failed with error: " + error.localizedDescription + " and suggestion: " + error.localizedRecoverySuggestion!)
        }
        )
    }
    
    func addScoreAndSubmitToGC(_ sender: AnyObject) {
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(bestScore)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func checkGCLeaderboard(_ sender: AnyObject) {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        self.view?.window?.rootViewController?.present(gcVC, animated: true, completion: nil)
    }
    
    func tutorial(){        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            self.showAlert()
        }
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.view?.window?.rootViewController?.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error!)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
                
        if let location = touch?.location(in: self){
            let nodeArray = self.nodes(at: location)
            
            if(canPlay){
                if(nodeArray.first?.name == "StartBtn"){
                    if let gameScene = GameScene(fileNamed: "GameScene"){
                        gameScene.scaleMode = .aspectFill
                        gameScene.characterIndex = self.characterIndex
                        gameScene.totalGold = self.totalGold
                        
                        self.view?.presentScene(gameScene)
                    }
                }
            }
            
            if(nodeArray.first?.name == "StoreBtn"){
                if let storeScene = StoreScene(fileNamed: "StoreScene"){
                    let transition = SKTransition.fade(withDuration: 1.0)
                    storeScene.scaleMode = .aspectFill
                    
                    self.view?.presentScene(storeScene, transition: transition)
                }
            }
            
            if(nodeArray.first?.name == "LeaderboardsBtn"){
                checkGCLeaderboard(LEADERBOARD_ID as AnyObject)
            }
            
            if(nodeArray.first?.name == "TutBtn"){
                tutorial()
            }
            
            if(nodeArray.first?.name == "AdBtn"){
                if let ad = self.ad {
                    if (!ad.expired) {
                        ad.show(withPresenting: (self.view?.window?.rootViewController)!)
                        let NewtotalGold = self.totalGold + 10
                        self.userDefaults.set(NewtotalGold, forKey: "totalGold")
                        self.userDefaults.synchronize()
                    }
                }
            }
            
            if(nodeArray.first?.name == "CharacterBtn"){
                if(characterIndex != characterArray.count - 1){
                    characterNameVar = characterIndex + 1
                    characterIndex? += 1
                }else{
                    characterNameVar = characterIndex + 1
                    characterIndex = 0
                }
                userDefaults.set(characterIndex, forKey: "characterChoice")
                userDefaults.synchronize()
                
                if(!characterArray[characterIndex].doesNotCost){
                    if(CostLbl != nil){
                        BuyBtnNode.removeFromParent()
                        CostLbl.removeFromParent()
                    }
                    canPlay = false
                    
                    cost = characterArray[characterIndex].coins
                    
                    BuyBtnNode.position = CGPoint(x: 120, y: -200)
                    BuyBtnNode.texture = SKTexture(image: #imageLiteral(resourceName: "BuyBtnTexture"))
                    BuyBtnNode.size = CGSize(width: 150, height: 35)
                    BuyBtnNode.name = "BuyBtn"
                    
                    self.CostLbl = SKLabelNode(fontNamed: "Arial")
                    self.CostLbl.text = "Cost: \(cost!)"
                    self.CostLbl.horizontalAlignmentMode = .center
                    self.CostLbl.position = CGPoint(x: -120, y: -210)
                    self.CostLbl.fontSize = 20
                    
                    addChild(BuyBtnNode)
                    addChild(CostLbl)
                    
                    platform.fillColor = .clear
                    platform.strokeColor = .gray
                    platform.fillTexture = nil
                    
                    base1.fillColor = .gray
                    base1.strokeColor = .gray
                    base1.fillTexture = SKTexture(image: #imageLiteral(resourceName: "questionMark"))
                    
                    base2.fillColor = .gray
                    base2.strokeColor = .gray
                    base2.fillTexture = SKTexture(image: #imageLiteral(resourceName: "questionMark"))
                }else{
                    canPlay = true
                    
                    if(CostLbl != nil){
                        BuyBtnNode.removeFromParent()
                        CostLbl.removeFromParent()
                    }
                    
                    switch characterArray[characterIndex!].design{
                        case is UIColor:
                            platform.fillColor = characterArray[characterIndex].design as! UIColor
                            platform.strokeColor = characterArray[characterIndex].design as! UIColor
                            platform.fillTexture = nil
                            
                            base1.fillColor = characterArray[characterIndex].design as! UIColor
                            base1.strokeColor = characterArray[characterIndex].design as! UIColor
                            base1.fillTexture = nil
                            
                            base2.fillColor = characterArray[characterIndex].design as! UIColor
                            base2.strokeColor = characterArray[characterIndex].design as! UIColor
                            base2.fillTexture = nil
                            break
                        case is SKTexture:
                            platform.fillColor = .white
                            platform.strokeColor = .clear
                            
                            base1.fillColor = .white
                            base1.strokeColor = .clear
                            base1.fillTexture = characterArray[characterIndex].design as? SKTexture
                            
                            base2.fillColor = .white
                            base2.strokeColor = .clear
                            base2.fillTexture = characterArray[characterIndex].design as? SKTexture
                            break
                        default:
                            // hmm
                            break
                    }
                }
            }
            
            if(nodeArray.first?.name == "BuyBtn"){
                //the only problem with this that i can tell is that when they close the app and re-run it, the
                //texture is locked again
                if(characterArray[characterIndex].coins! <= totalGold){
                    totalGold = totalGold - characterArray[characterIndex].coins!
                    userDefaults.set(totalGold, forKey: "totalGold")
                    userDefaults.synchronize()
                    
                    userDefaults.set(true, forKey: characterArray[characterIndex].name)
                    userDefaults.synchronize()
                    
                    BuyBtnNode.removeFromParent()
                    CostLbl.removeFromParent()
                    
                    characterArray[characterIndex].doesNotCost = true
                    canPlay = true
                    
                    switch characterArray[characterIndex!].design{
                        case is UIColor:
                            platform.fillColor = characterArray[characterIndex].design as! UIColor
                            platform.strokeColor = characterArray[characterIndex].design as! UIColor
                            platform.fillTexture = nil
                            
                            base1.fillColor = characterArray[characterIndex].design as! UIColor
                            base1.strokeColor = characterArray[characterIndex].design as! UIColor
                            base1.fillTexture = nil
                            
                            base2.fillColor = characterArray[characterIndex].design as! UIColor
                            base2.strokeColor = characterArray[characterIndex].design as! UIColor
                            base2.fillTexture = nil
                            break
                        case is SKTexture:
                            platform.fillColor = .white
                            platform.strokeColor = .clear
                            
                            base1.fillColor = .white
                            base1.strokeColor = .clear
                            base1.fillTexture = characterArray[characterIndex].design as? SKTexture
                            
                            base2.fillColor = .white
                            base2.strokeColor = .clear
                            base2.fillTexture = characterArray[characterIndex].design as? SKTexture
                            break
                        default:
                            // hmm
                            break
                    }
                }
            }
        }
    }
}
