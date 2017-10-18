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
        setupWit()
    }
    
    // MARK: IBAction
    @IBAction func recordingButtonClicked(sender: UIButton) {
        if Wit.sharedInstance().isRecording() {
            handleStop()
        } else {
            handleStart()
        }
    }
    
    // MARK: WitDelegate
    func witDidGraspIntent(_ outcomes: [Any]!,
                           messageId: String!,
                           customData: Any!,
                           error: Error!) {
        if outcomes != nil && outcomes.count > 0 {
            let outcome = outcomes[0] as! [String : Any]
            guard let entities = outcome["entities"] as? [String : Any] else {
                return
            }
            updateProducts(fromEntities: entities)
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    func witDidRecognizePreviewText(_ previewText: String!, final isFinal: Bool) {
        self.transcriptedText.text = previewText
        stopTimer()
        self.timer = Timer.scheduledTimer(withTimeInterval: 3,
                                          repeats: false,
                                          block: { [unowned self] _ in
                                            self.handleStop()
                                          })
    }
    
    // MARK: private
    private func handleStop() {
        Wit.sharedInstance().stop()
        recordingButton.setTitle("Start recording", for: .normal)
        stopTimer()
    }
    
    private func updateProducts(fromEntities entities: [String : Any]) {
        let newProducts = self.extractProducts(fromEntities: entities, key: "add")
        let toBeRemovedProducts = self.extractProducts(fromEntities: entities, key: "remove")
        var tmp = addedProducts
        tmp.append(contentsOf: newProducts)
        addedProducts = []
        for product in tmp {
            if !toBeRemovedProducts.contains(product) {
                addedProducts.append(product)
            }
        }
    }
    
    private func handleStart() {
        Wit.sharedInstance().start()
        transcriptedText.text = ""
        recordingButton.setTitle("Stop recording", for: .normal)
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func setupWit() {
        Wit.sharedInstance().delegate = self
        Wit.sharedInstance().detectSpeechStop = .full
        Wit.sharedInstance().vadTimeout = 3000
        Wit.sharedInstance().vadSensitivity = 100
    }
    
    private func extractProducts(fromEntities entites: [String : Any], key: String) -> [String] {
        guard let toBeAdded = entites[key] as? Array<[String : Any]> else {
            return []
        }
        
        var products = [String]()
        for product in toBeAdded {
            if let value = product["value"] as? String {
                products.append(value)
            }
        }
        
        return products
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ProductCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ProductCell")
        }
        
        cell?.textLabel?.text = addedProducts[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedProducts.count
    }

}

