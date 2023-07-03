//
//  Series.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/3/23.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Series: Object {
    @Persisted var trackId: String = ""
    @Persisted var title: String = ""
    @Persisted var type: String = ""
    @Persisted var poster: String = ""
    @Persisted var isFavorite: Bool = false
    
    convenience init(_ json: JSON) {
        self.init()
        
        self.title = json["Title"].stringValue
        self.trackId = json["imdbID"].stringValue
        self.type = json["Type"].stringValue
        self.poster = json["Poster"].stringValue   
    }
    
    convenience init(trackId: String, 
                     title: String,
                     type: String,
                     poster: String,
                     isFavorite: Bool) {
        
        self.init()
        
        self.trackId = trackId
        self.title = title
        self.type = type
        self.poster = poster
        self.isFavorite = isFavorite
    }   
}
