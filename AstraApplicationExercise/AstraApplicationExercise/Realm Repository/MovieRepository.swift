//
//  MovieRepository.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation

class MovieRepository {
    
    let realm = RealmManager.shared
    static let shared = MovieRepository()
    private init() {}
    
    func getAllMovies() -> [Movie] {
        let item = realm.getAll(Movie())
        return [Movie] (item)
    }
    
    func create(_ movie: Movie) {
        let obj = Movie(trackId: movie.trackId, 
                        title: movie.title, 
                        price: movie.price, 
                        genre: movie.genre, 
                        artwork: movie.artwork, 
                        shortDesc: movie.shortDesc, 
                        longDesc: movie.longDesc, 
                        isFavorite: movie.isFavorite)
        realm.create(obj)
    }
    
    func create(_ movies: [Movie]) {
        realm.create(movies)
    }
    
    func delete(id: Int) {
        if let obj = realm.getAll(Movie()).filter({$0.trackId == id}).first {
            realm.delete(obj)
        }
    }
    
    func deleteAll() {
        let results = realm.getAll(Movie())
        realm.delete(results)
    }
    
    func updateFavorite(_ oldMovie: Movie, newMovie: Movie) {
        realm.update(oldMovie, with: ["isFavorite": newMovie.isFavorite])
    }
    
    func isFavoriteMovie(movie: Movie) -> Bool {
        if let object = realm.getAll(Movie()).filter({$0.trackId == movie.trackId}).first {
            return object.isFavorite
        } else {
            return false
        }
    }
    
    func search(_ text: String) -> [Movie] {
        let objects = realm.getAll(Movie())
        let predicate = NSPredicate(format: "(title contains[cd] %@) OR (genre contains[cd] %@) OR (shortDesc contains[cd] %@) OR (longDesc contains[cd] %@)", text, text, text, text)
        let results = [Movie] (objects.filter(predicate))
        if results.count > 0 {
            return results
        } else {
            return getAllMovies()
        }
    }
}
