//
//  ViewController.swift
//  SentimentAnalysis
//
//  Created by Martin Mitrevski on 01.07.17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var orderedWords = [String]()
    private let cellIdentifier = "MovieCell"
    private var selectedIndex: IndexPath?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: implement this method with code from the book.
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        // TODO: implement this method with code from the book.
        
        return cell!
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: implement this method with code from the book.
    }
    
    // MARK: Actions
    @IBAction func addButtonClicked(button: UIButton) {
        // TODO: implement this method with code from the book.
    }

}

