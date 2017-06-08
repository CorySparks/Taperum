//
//  TutorialScene.swift
//  Taperum
//
//  Created by Cory Sparks on 6/8/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import SpriteKit
import UIKit


class firstTut: SKScene{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodeArray = self.nodes(at: location)
            
            if(nodeArray.first?.name == "Next"){
                let transition = SKTransition.fade(withDuration: 1.0)
                if let SecondTut = secondTut(fileNamed: "secondTut"){
                    SecondTut.scaleMode = .aspectFill

                    self.view?.presentScene(SecondTut, transition: transition)
                }
                
            }
            
            if(nodeArray.first?.name == "Menu"){
                let transition = SKTransition.fade(withDuration: 1.0)
                if let menuScene = MenuScene(fileNamed: "MenuScene"){
                    menuScene.scaleMode = .aspectFill
                    
                    self.view?.presentScene(menuScene, transition: transition)
                }
                
            }
        }
    }
    
}
