//
//  MovieViewModel.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation

class MovieViewModel {

    var movies = [Movie]()
    var movie: Movie?
    
    
    let headerTitle = "Movies"
    
    var textArtwork: String {
        return movie?.artwork ?? ""
    }
    
    var textHeaderTitle: String {
        return "Movies"
    }
    
    var textTitle: String {
        return movie?.title ?? ""
    }
    
}
