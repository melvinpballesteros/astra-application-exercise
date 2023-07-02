//
//  MovieViewModel.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation
import SwiftyJSON

class MovieViewModel {

    var movies = [Movie]()
    var movie: Movie?
    
    
    let headerTitle = "Movies"
    let searchTitle = "Search"
    
    var textArtwork: String {
        return movie?.artwork ?? ""
    }
    
    var textHeaderTitle: String {
        return "Movies"
    }
    
    var textTitle: String {
        return movie?.title ?? ""
    }
    
    var textGenre: String {
        return movie?.genre ?? ""
    }
    
    var textPrice: String {
        let formattedPrice = "$ \(movie?.price ?? 0.00)"
        return formattedPrice
    }
    
    var textLongDesc: String {
        let appendText = "Description:\n\(movie?.longDesc ?? "")"
        return appendText
    }
    
    var textShortDesc: String {
        return movie?.shortDesc ?? ""
    }
    
    var errorMessage: String = ""

    
    func fetchMovies(success: @escaping(()-> Void), failed: @escaping(()-> Void)) {
        ApiManager.shared.getRequest(Api.movie) { (data, error) in
            if error == nil {
                guard let data = data else { return }
                self.saveMovies(data: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    success()
                }
            } else {
                self.errorMessage = error?.localizedDescription ?? "Error loading page, please try again."
                failed()
            }
        }
    }
    
    func fetchMovies(completion: @escaping(() -> Void)) {
        ApiManager.shared.getRequest(Api.movie) { (data, error) in
            if error == nil {
                guard let data = data else { return }
                guard let json = try? JSON(data: data) else { return }
                print(json)           
                // save to cached
            } else {
                self.errorMessage = error?.localizedDescription ?? "Error loading page, please try again."
                // fetch cached if any
            }
            
            completion()
        }
    }
    
    func setSelectedMovie(_ movie: Movie) {
        self.movie = movie
    }
    
    func saveMovies(data: Data) {
        /// Removed previous data before saving updated data
        deleteAllData()
        /// Parse data into json
        guard let json = try? JSON(data: data) else { return }
        let results = json["results"].array
        let objects = results?.map( {Movie($0)}) ?? [Movie]()
        
        // Save to realm
        MovieRepository.shared.create(objects)
        // Fetch Data
        fetchLocalData()
    }
    
    func fetchLocalData() {
        movies = MovieRepository.shared.getAll()
    }
    
    func deleteAllData() {
        MovieRepository.shared.deleteAll()
    }
    
    func searchMovies(_ searchText: String) {
        movies = MovieRepository.shared.search(searchText)
    }
    
}
