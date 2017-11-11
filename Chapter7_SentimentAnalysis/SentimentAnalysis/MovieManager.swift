//
//  Movie.swift
//  SentimentAnalysis
//
//  Created by Martin Mitrevski on 09.07.17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import Foundation

class MovieManager {
    
    private let moviesKey = "moviesKey"
    private let positivesKey = "positivesKey"
    private let negativesKey = "negativesKey"
    private var savedMovies = Dictionary<String, Dictionary<String, Array<String>>>()
    static let sharedInstance = MovieManager()
    
    
    init() {
        if let saved = UserDefaults.standard.value(forKey: moviesKey) {
            savedMovies = saved as! Dictionary<String, Dictionary<String, Array<String>>>
        }
    }
    
    func movies() -> Dictionary<String, Dictionary<String, Array<String>>> {
        return savedMovies
    }
    
    func addMovie(withTitle title:String) {
        let moviesInfo: Dictionary<String, Array<String>> = [positivesKey : [], negativesKey : []]
        savedMovies[title] = moviesInfo
        saveChanges()
    }
    
    func addReview(toMovieTitle movieTitle: String, review: String, sentiment: ReviewSentiment) {
        var key = positivesKey
        if sentiment == .Bad {
            key = negativesKey
        }
        if var movieInfo = savedMovies[movieTitle] {
            var reviews = [String]()
            reviews = movieInfo[key]!
            reviews.append(review)
            movieInfo[key] = reviews
            savedMovies[movieTitle] = movieInfo
        } else {
            var movieInfo: Dictionary<String, Array<String>> = [positivesKey : [], negativesKey : []]
            let reviews = [review]
            movieInfo[key] = reviews
            savedMovies[movieTitle] = movieInfo
        }
        saveChanges()
    }
    
    func positiveReviews(forMovieTitle movieTitle: String) -> [String] {
        return reviews(forMovieTitle: movieTitle, key: positivesKey)
    }
    
    func negativeReviews(forMovieTitle movieTitle: String) -> [String] {
        return reviews(forMovieTitle: movieTitle, key: negativesKey)
    }
    
    private func reviews(forMovieTitle movieTitle: String, key: String) -> [String] {
        if let movieInfo = savedMovies[movieTitle] {
            return movieInfo[key]!
        } else {
            return []
        }
    }
    
    private func saveChanges() {
        UserDefaults.standard.set(savedMovies, forKey: moviesKey)
        UserDefaults.standard.synchronize()
    }
}
