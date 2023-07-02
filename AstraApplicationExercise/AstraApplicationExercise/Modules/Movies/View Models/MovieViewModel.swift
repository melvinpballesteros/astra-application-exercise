//
//  MovieViewModel.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation
import SwiftyJSON
import RealmSwift

class MovieViewModel {

    var movies = [Movie]()
    // var movie: Movie?
    
    var index: Int?
    
    var notificationToken: NotificationToken?
    
    var movie: Movie {
        guard let index = index else { return Movie() }
        return movies[index]
    }
    
    
    let headerTitle = "Movies"
    let searchTitle = "Search"
    
    var textArtwork: String {
        return movie.artwork
    }
    
    var textHeaderTitle: String {
        return "Movies"
    }
    
    var textTitle: String {
        return movie.title
    }
    
    var textGenre: String {
        return movie.genre
    }
    
    var textPrice: String {
        let formattedPrice = "$ \(movie.price)"
        return formattedPrice
    }
    
    var textLongDesc: String {
        let appendText = "Description:\n\(movie.longDesc)"
        return appendText
    }
    
    var textShortDesc: String {
        return movie.shortDesc
    }
    
    var isLiked: Bool { 
        return movie.isFavorite
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
        // self.movie = movie
    }
    
    func saveMovies(data: Data) {
        /// Removed previous data before saving updated data
        // deleteAllData()
        /// Parse data into json
        guard let json = try? JSON(data: data) else { return }
        let results = json["results"].array
        movies = results?.map( {Movie($0)}) ?? [Movie]()
    }
    
    func fetchLocalData() {
        movies = MovieRepository.shared.getAllMovies()
    }
    
    func deleteAllData() {
        MovieRepository.shared.deleteAll()
    }
    
    func searchMovies(_ searchText: String) {
        movies = MovieRepository.shared.search(searchText)
    }
    
    func likeUnlikeMovie(index: Int) {
        /// Get the initial value of isFavorite
        let value = movies[index].isFavorite
        /// Get the current obj in the list of movies 
        let currentObj = movies[index]
        /// Update or set the new value of isFavorite
        movies[index].isFavorite = (!value) ? true : false
        /// Save or Delete to local database realm
        (!value) ? MovieRepository.shared.create(movies[index]) :  MovieRepository.shared.delete(id: currentObj.trackId) //MovieRepository.shared.delete(id: currentObj.trackId)
    }
    
    func checkFavoriteMovie(index: Int) {
        /// Get the current object from the list of movies
        let obj = movies[index]
        /// Check if the object exist in the local database and get the bool value of isFavorite.
        let isFavoriteLocal = MovieRepository.shared.isFavoriteMovie(movie: obj)
        /// Compare the object item from the list of movies (server item list) and compare it to the local item database
        /// If not equal, update the object item from the list of movies.  
        if obj.isFavorite != isFavoriteLocal {
            movies[index].isFavorite = isFavoriteLocal
        }
    }
    
    func detailPageTapFavorite(withFavoriteButton button: UIButton) {
        guard let index = index else { return }
        
        let image = UIImage(named: !isLiked ? "heart-white-filled" : "heart-white")
        button.setImage(image, for: .normal)
        
        likeUnlikeMovie(index: index)
    }
    
    func getFavoriteStatus(withFavoriteButton button: UIButton) {
        let image = UIImage(named: isLiked ? "heart-white-filled" : "heart-white")
        button.setImage(image, for: .normal)
    }
    
    func setupRealmObserver(tableView: UITableView) {
        let realm = try! Realm()
        let results = realm.objects(Movie.self)
        
        notificationToken = results.observe { change in
            switch change {
            case .update:
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            default: ()
            }
        }
    }
    
}
