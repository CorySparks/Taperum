//
//  TaperumProducts.swift
//  Taperum
//
//  Created by Cory Sparks on 6/10/17.
//  Copyright © 2017 The Glass House Studios. All rights reserved.
//

import Foundation

public struct TaperumProducts {
    
    public static let Coins300IAP = "300CoinsTaperum"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [TaperumProducts.Coins300IAP]
    
    public static let store = IAPHelper(productIds: TaperumProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
