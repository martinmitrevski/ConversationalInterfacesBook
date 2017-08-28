//
//  Util.swift
//  SentimentAnalysis
//
//  Created by Martin Mitrevski on 09.07.17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import Foundation
import CoreML
import UIKit

public let ArraySize = 39659

func convert(string: String, wordCountings: Dictionary<String, Dictionary<String, Int>>)
    -> MLMultiArray {
    guard let mlMultiArray = try? MLMultiArray(shape:[NSNumber(integerLiteral: ArraySize)],
                                               dataType:MLMultiArrayDataType.double) else {
                                                fatalError("Unexpected runtime error. MLMultiArray")
    }
    
    for i in 0..<ArraySize {
        mlMultiArray[i] = 0
    }
    
    let separatedWords: [String] = string
        .components(separatedBy: .punctuationCharacters)
        .joined()
        .components(separatedBy: .whitespaces)
        .filter{!$0.isEmpty}
    
    for word in separatedWords {
        if let wordInfo = wordCountings[word] {
            let index = wordInfo["index"]!
            let countInDoc = wordInfo["count"]!
            let wordOccurencies = occurencies(ofWord: word, inList: separatedWords)
            let tf = Double(wordOccurencies) / Double(separatedWords.count)
            let idf = log(Double(wordCountings.count) / Double(countInDoc))
            mlMultiArray[index] = NSNumber(value: tf * idf)
        }
    }
    
    return mlMultiArray
}

private func occurencies(ofWord word: String, inList list: [String]) -> Int {
    var count = 0
    for entry in list {
        if entry == word {
            count += 1
        }
    }
    return count
}

func alertForAddingItems(title: String,
                         placeholder: String)
    -> UIAlertController {
        
        let alertController = UIAlertController(title: title,
                                                message: nil,
                                                preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        
        return alertController
}

func addActions(toAlertController alertController: UIAlertController,
                saveActionHandler: @escaping ((UIAlertAction) -> Swift.Void))
    -> UIAlertController {
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: saveActionHandler)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: { action in
                                            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        return alertController
}
