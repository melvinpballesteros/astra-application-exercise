//
//  Movie.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Movie: Object {
    @Persisted var trackId: Int = 0
    @Persisted var title: String = ""
    @Persisted var price: Double = 0
    @Persisted var genre: String = ""
    @Persisted var artwork: String = ""
    @Persisted var longDesc: String = ""
    @Persisted var shortDesc: String = ""
    @Persisted var isFavorite: Bool = false
    
    convenience init(_ json: JSON) {
        self.init()
        
        self.title = json["trackName"].stringValue
        self.trackId = json["trackId"].intValue
        self.price = json["trackPrice"].doubleValue
        self.genre = json["primaryGenreName"].stringValue
        self.artwork = json["artworkUrl100"].stringValue
        self.longDesc = json["longDescription"].stringValue
        self.shortDesc = json["shortDescription"].stringValue   
    }
    
    convenience init(trackId: Int, 
                     title: String,
                     price: Double,
                     genre: String,
                     artwork: String,
                     shortDesc: String,
                     longDesc: String,
                     isFavorite: Bool) {
        
        self.init()
        
        self.trackId = trackId
        self.title = title
        self.price = price
        self.genre = genre
        self.artwork = artwork
        self.shortDesc = shortDesc
        self.longDesc = longDesc
        self.isFavorite = isFavorite
    }
}

