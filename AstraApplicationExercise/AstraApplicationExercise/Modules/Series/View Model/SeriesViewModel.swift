//
//  SeriesViewModel.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/3/23.
//

import Foundation
import SwiftyJSON
import RealmSwift

class SeriesViewModel {
    
    let headerTitle = "Series"
    let searchTitle = "Search"
    
    
    var errorMessage: String = ""
    var series = [Series]()
    var index: Int?
    var notificationToken: NotificationToken?
    
    var itemSeries: Series {
        guard let index = index else { return Series() }
        return series[index]
    }
    
    
    var textPoster: String {
        return itemSeries.poster
    }
    
    var textTitle: String {
        return itemSeries.title
    }
    
    var textType: String {
        return itemSeries.type
    }
    
    var textID: String {
        return itemSeries.trackId
    }
    
    var isLiked: Bool { 
        return itemSeries.isFavorite
    }
    
    func fetchSeries(success: @escaping(()-> Void), failed: @escaping(()-> Void)) {
        ApiManager.shared.getRequest(Api.season) { (data, error) in
            if error == nil {
                guard let data = data else { return }
                
                self.saveSeries(data: data)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    success()
                }
            } else {
                self.errorMessage = error?.localizedDescription ?? "Error loading page, please try again."
                self.fetchSavedFavorites()
                failed()
            }
        }
    }
    
    func saveSeries(data: Data) {     
        /// Removed previous data before saving updated data
        deleteAllData()
        /// Parse data into json
        guard let json = try? JSON(data: data) else { return }
        let results = json["Search"].array
        series = results?.map( {Series($0)}) ?? [Series]()
        
        SeriesRepository.shared.create(series)
    }
    
    func deleteAllData() {
        SeriesRepository.shared.deleteAll()
    }
    
    func fetchSavedFavorites() {
        series = SeriesRepository.shared.getAllSeries()
    }
    
    func likeUnlikeMovie(index: Int) {
        /// Get the initial value of isFavorite
        let value = series[index].isFavorite
        /// Get the current obj in the list of movies 
        let currentObj = series[index]
        /// Update or set the new value of isFavorite
        series[index].isFavorite = (!value) ? true : false
        /// Save or Delete to local database realm
        (!value) ? SeriesRepository.shared.create(series[index]):  SeriesRepository.shared.delete(currentObj.trackId) 
    }
    
    func checkFavoriteMovie(index: Int) {
        /// Get the current object from the list of movies
        let obj = series[index]
        /// Check if the object exist in the local database and get the bool value of isFavorite.
        let isFavoriteLocal = SeriesRepository.shared.isFavoriteSeries(obj)
        /// Compare the object item from the list of movies (server item list) and compare it to the local item database
        /// If not equal, update the object item from the list of movies.  
        if obj.isFavorite != isFavoriteLocal {
            series[index].isFavorite = isFavoriteLocal
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
        let results = realm.objects(Series.self)
        
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
    
    func searchSeries(_ searchText: String) {
        series = SeriesRepository.shared.search(searchText)
    }
    
}
