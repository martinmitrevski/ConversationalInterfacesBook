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
    var currentReviews = [String]()
    let movieReviews = MovieReviews()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movieTitle
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        loadWordCountings()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSentiment == .Good {
            return MovieManager.sharedInstance.positiveReviews(forMovieTitle: movieTitle).count
        } else {
            return MovieManager.sharedInstance.negativeReviews(forMovieTitle: movieTitle).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ReviewCell
        var review = ""
        if currentSentiment == .Good {
            review = MovieManager
                .sharedInstance
                .positiveReviews(forMovieTitle: movieTitle)[indexPath.row]
        } else {
            review = MovieManager
                .sharedInstance
                .negativeReviews(forMovieTitle: movieTitle)[indexPath.row]
        }
        cell.reviewLabel.text = review
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Actions
    @IBAction func addButtonClicked(button: UIButton) {
        let alertController = self.alertForAddingItems()
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func segmentedValueChanged(control: UISegmentedControl) {
        if control.selectedSegmentIndex == 0 {
            currentSentiment = .Good
        } else {
            currentSentiment = .Bad
        }
        updateState()
    }
    
    // MARK: private
    
    private func alertForAddingItems() -> UIAlertController {
        let alertController = SentimentAnalysis.alertForAddingItems(title: "Please give movie review",
                                                                    placeholder: "Movie review")
        return addActions(toAlertController: alertController,
                          saveActionHandler: { [unowned self] action in
                            let textField = alertController.textFields![0]
                            if let text = textField.text {
                                if text != "" {
                                    MovieManager.sharedInstance.addReview(toMovieTitle: self.movieTitle,
                                                                          review: text,
                                                                          sentiment: self.sentiment(forReview: text))
                                    self.tableView.reloadData()
                                }
                            }
                            alertController.dismiss(animated: true, completion: nil)
        })
    }
    
    private func sentiment(forReview review: String) -> ReviewSentiment {
        let mlMultiArray = SentimentAnalysis.convert(string: review, wordCountings: wordCountings)
        guard let predictionOutput = try? movieReviews.prediction(input: mlMultiArray) else {
            print("Error producing sentiment, setting good sentiment as default")
            return .Good
        }
        
        return sentiment(forPrediction: predictionOutput)
    }
    
    private func sentiment(forPrediction prediction: MovieReviewsOutput) -> ReviewSentiment {
        let goodSentiment = prediction.classProbability["good"]!
        let badSentiment = prediction.classProbability["bad"]!
        if goodSentiment > badSentiment {
            return .Good
        } else {
            return .Bad
        }
    }
    
    private func updateState() {
        tableView.reloadData()
    }
    
    private func loadWordCountings() {
        let wordsUrl = Bundle.main.url(forResource: "words", withExtension: "json")!
        do {
            let wordsData = try Data.init(contentsOf: wordsUrl)
            wordCountings = try JSONSerialization.jsonObject(with: wordsData,
                                                             options: .allowFragments)
                as! Dictionary<String, Dictionary<String, Int>>
        } catch {
            print("error loading words")
        }
    }
}
