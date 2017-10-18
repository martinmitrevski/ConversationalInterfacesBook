//
//  WebViewController.swift
//  NLPShowcase
//
//  Created by Martin Mitrevski on 6/27/17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var postTitle: String!
    var html: String!
    var keywords: [String]!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var detectedLanguage: UILabel!
    let languageTagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = postTitle
        tags.text = keywords.joined(separator: " ")
        webView.loadHTMLString(html, baseURL: nil)
        detectLanguage()
        checkOrthography()
    }
    
    private func detectLanguage() {
        languageTagger.string = postTitle
        let language = languageTagger.dominantLanguage!
        detectedLanguage.text = "Detected language: \(language)"
    }
    
    private func checkOrthography() {
        languageTagger.string = postTitle
        var range = NSRange(location: 0, length: postTitle.count)
        if let ortoghraphy = languageTagger.orthography(at: 0, effectiveRange: &range) {
            print(ortoghraphy.dominantScript)
            print(ortoghraphy.dominantLanguage)
            print(ortoghraphy.languageMap)
            print(ortoghraphy.allLanguages)
        }
    }

}
