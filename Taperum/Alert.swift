//
//  Alert.swift
//  Taperum
//
//  Created by Cory Sparks on 6/8/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import Foundation
import SpriteKit

protocol Alert { }
extension Alert where Self: SKScene {
    
    func showAlert(){
        let alertController = UIAlertController(title: "Don't Know How to Play?", message: "", preferredStyle: .alert)
        let learnAction = UIAlertAction(title: "Learn how to play!", style: .default) {
            (result : UIAlertAction) -> Void in
            
            if let FirstTut = firstTut(fileNamed: "firstTut"){
                FirstTut.scaleMode = .aspectFill
                
                self.view?.presentScene(FirstTut)
            }
        }
        
        let cancalAction = UIAlertAction(title: "Nah, I'm an expert", style: .cancel) {
            (result : UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(learnAction)
        alertController.addAction(cancalAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
