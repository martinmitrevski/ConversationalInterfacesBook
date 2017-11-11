//
//  SpeechHelper.swift
//  SpeechPlayground
//
//  Created by Martin Mitrevski on 05/03/17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import UIKit

class SpeechHelper: NSObject {
    
    class func loadProducts() -> Set<String> {
        var products = Set<String>()
        let fileUrl = Bundle.main.url(forResource: "products", withExtension: "json")
        do {
            let jsonData = try Data(contentsOf: fileUrl!)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                as! [String: Array<String>]
            if let loadedProducts = json["products"] {
                for product in loadedProducts {
                    products.insert(product)
                }
            }
        } catch {
            print("error loading products")
        }
        
        return products
    }
    
    class func removalWords() -> Set<String> {
        return ["delete", "erase", "remove"]
    }
    
    class func stoppingWords() -> Set<String> {
        return ["stop", "done"]
    }
}
