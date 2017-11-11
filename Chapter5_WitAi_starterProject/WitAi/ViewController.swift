//
//  ViewController.swift
//  WitAi
//
//  Created by Martin Mitrevski on 02.09.17.
//  Copyright © 2017 Mitrevski. All rights reserved.
//

import UIKit
import Wit

class ViewController: UIViewController, UITableViewDataSource, WitDelegate {
    
    private var addedProducts: [String] = [String]()
    private var timer: Timer?
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var transcriptedText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBAction
    @IBAction func recordingButtonClicked(sender: UIButton) {
       
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ProductCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ProductCell")
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}

