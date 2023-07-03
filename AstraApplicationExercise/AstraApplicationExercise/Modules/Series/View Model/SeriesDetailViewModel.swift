//
//  SeriesDetailViewModel.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/3/23.
//

import Foundation
import SwiftyJSON

class SeriesDetailViewModel {
    
    var title: String = ""
    var genre: String = ""
    var plot: String = ""
    var posterUrl: String = ""
    
    var errorMessage: String = ""
    
    func fetchSerieDetailInfo(id: String, success: @escaping(() -> Void), failed: @escaping(()-> Void)) {
        let urlString = "\(Api.seasonDetails)\(id)"
        ApiManager.shared.getRequest(urlString) { (data, error) in
            if error == nil {
                guard let data = data else { return }
                guard let json = try? JSON(data: data) else { return }
                
                self.title = json["Title"].stringValue
                self.genre = json["Genre"].stringValue
                self.plot = "Plot:\n\(json["Plot"].stringValue)"
                self.posterUrl = json["Poster"].stringValue
                
                success()
            } else {
                self.errorMessage = error?.localizedDescription ?? "Unknown Error"
                failed()
            }
        }
    } 
}
