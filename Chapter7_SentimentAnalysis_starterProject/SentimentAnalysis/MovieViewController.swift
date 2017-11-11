//
//  MovieViewController.swift
//  SentimentAnalysis
//
//  Created by Martin Mitrevski on 09.07.17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import UIKit

enum ReviewSentiment {
    case Good
    case Bad
}

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movieTitle: String!
    private let cellIdentifier = "ReviewCell"
    @IBOutlet weak var tableView: UITableView!
    private var currentSentiment: ReviewSentiment = .Good
    private var wordCountings = Dictionary<String, Dictionary<String, Int>>()
    let movieReviews = MovieReviews()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movieTitle
        // TODO: implement this method with code from the book.
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: implement this method with code from the book.
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ReviewCell
        // TODO: implement this method with code from the book.
        return cell
    }
    
    // MARK: Actions
    @IBAction func addButtonClicked(button: UIButton) {
        // TODO: implement this method with code from the book.
    }
    
    @IBAction func segmentedValueChanged(control: UISegmentedControl) {
        // TODO: implement this method with code from the book.
    }
    
}
