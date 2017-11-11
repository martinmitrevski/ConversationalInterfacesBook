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
    }

}
