//
//  MusicVideo.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation
import SwiftyJSON
import RealmSwift

class MusicVideo: Object {
    @Persisted var trackId: Int = 0
    @Persisted var title: String = ""
    @Persisted var artistName: String = ""
    @Persisted var artwork: String = ""
    @Persisted var previewUrl: String = ""
    @Persisted var releaseDate: String = ""
    @Persisted var genre: String = ""
    @Persisted var price: Double = 0
    @Persisted var isFavorite: Bool = false
    
    convenience init(_ json: JSON) {
        self.init()
        
        self.title = json["collectionName"].stringValue
        self.trackId = json["trackId"].intValue
        self.price = json["trackPrice"].doubleValue
        self.genre = json["primaryGenreName"].stringValue
        self.artwork = json["artworkUrl100"].stringValue
        self.previewUrl = json["previewUrl"].stringValue
        self.releaseDate = json["releaseDate"].stringValue   
    }
    
    convenience init(trackId: Int, 
                     title: String,
                     price: Double,
                     genre: String,
                     artwork: String,
                     previewUrl: String,
                     releaseDate: String,
                     isFavorite: Bool) {
        
        self.init()
        
        self.trackId = trackId
        self.title = title
        self.price = price
        self.genre = genre
        self.artwork = artwork
        self.previewUrl = previewUrl
        self.releaseDate = releaseDate
        self.isFavorite = isFavorite
    }
    
}
