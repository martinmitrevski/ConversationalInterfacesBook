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
        return MovieManager.sharedInstance.movies().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let movieTitle = Array(MovieManager.sharedInstance.movies().keys)[indexPath.row]
        cell?.textLabel?.text = movieTitle
        
        return cell!
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath
        performSegue(withIdentifier: "showMovieReviews", sender: self)
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieReviews" {
            let movieTitle = Array(MovieManager.sharedInstance.movies().keys)[selectedIndex!.row]
            let next = segue.destination as! MovieViewController
            next.movieTitle = movieTitle
        }
    }
    
    // MARK: Actions
    @IBAction func addButtonClicked(button: UIButton) {
        let alertController = self.alertForAddingItems()
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: private
    
    private func alertForAddingItems() -> UIAlertController {
        let alertController = SentimentAnalysis.alertForAddingItems(title: "Please provide movie title",
                                                  placeholder: "Movie title")
        return addActions(toAlertController: alertController,
                          saveActionHandler: { [unowned self] action in
                            let textField = alertController.textFields![0]
                            if let text = textField.text {
                                if text != "" {
                                    MovieManager.sharedInstance.addMovie(withTitle: text)
                                    self.tableView.reloadData()
                                }
                            }
                            alertController.dismiss(animated: true, completion: nil)
        })
    }


}

