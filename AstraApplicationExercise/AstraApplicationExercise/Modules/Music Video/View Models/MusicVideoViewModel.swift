//
//  MusicViewModel.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation
import SwiftyJSON
import RealmSwift

class MusicVideoViewModel {
    
    let headerTitle = "Music Video"
    let searchTitle = "Search"
    
    var errorMessage: String = ""
    var musicVideos = [MusicVideo]()
    var index: Int?
    var notificationToken: NotificationToken?
    
    var musicVideo: MusicVideo {
        guard let index = index else { return MusicVideo() }
        return musicVideos[index]
    }
    
    
    var textArtwork: String {
        return musicVideo.artwork
    }
    
    var textTitle: String {
        return musicVideo.title
    }
    
    var textGenre: String {
        return musicVideo.genre
    }
    
    var textPrice: String {
        let formattedPrice = "$ \(musicVideo.price)"
        return formattedPrice
    }
    
    var previewUrl: String {
        return musicVideo.previewUrl
    }
    
    var isLiked: Bool { 
        return musicVideo.isFavorite
    }

    func fetchMusicVideos(success: @escaping(()-> Void), failed: @escaping(()-> Void)) {
        ApiManager.shared.getRequest(Api.musicVideo) { (data, error) in
            if error == nil {
                guard let data = data else { return }
                guard let json = try? JSON(data: data) else { return }
            
                self.saveMusicVideos(data: data)
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
    
    func saveMusicVideos(data: Data) {     
        /// Removed previous data before saving updated data
        deleteAllData()
        /// Parse data into json
        guard let json = try? JSON(data: data) else { return }
        let results = json["results"].array
        musicVideos = results?.map( {MusicVideo($0)}) ?? [MusicVideo]()
        
        MusicVideoRepository.shared.create(musicVideos)
    }
    
    func deleteAllData() {
        MusicVideoRepository.shared.deleteAll()
    }
    
    func fetchSavedFavorites() {
        musicVideos = MusicVideoRepository.shared.getAllMusicVideos()
    }
    
    func likeUnlikeMovie(index: Int) {
        /// Get the initial value of isFavorite
        let value = musicVideos[index].isFavorite
        /// Get the current obj in the list of movies 
        let currentObj = musicVideos[index]
        /// Update or set the new value of isFavorite
        musicVideos[index].isFavorite = (!value) ? true : false
        /// Save or Delete to local database realm
        (!value) ? MusicVideoRepository.shared.create(musicVideos[index]) :  MusicVideoRepository.shared.delete(currentObj.trackId) //MovieRepository.shared.delete(id: currentObj.trackId)
    }
    
    func checkFavoriteMovie(index: Int) {
        /// Get the current object from the list of movies
        let obj = musicVideos[index]
        /// Check if the object exist in the local database and get the bool value of isFavorite.
        let isFavoriteLocal = MusicVideoRepository.shared.isFavoriteMovie(obj)
        /// Compare the object item from the list of movies (server item list) and compare it to the local item database
        /// If not equal, update the object item from the list of movies.  
        if obj.isFavorite != isFavoriteLocal {
            musicVideos[index].isFavorite = isFavoriteLocal
        }
    }
    
    func detailPageTapFavorite(withFavoriteButton button: UIButton) {
        guard let index = index else { return }
        
        let image = UIImage(named: !isLiked ? "heart-white-filled" : "heart-white")
        button.setImage(image, for: .normal)
        
        likeUnlikeMovie(index: index)
    }
    
    func searchMusicVideos(_ searchText: String) {
        musicVideos = MusicVideoRepository.shared.search(searchText)
    }
    
    func getFavoriteStatus(withFavoriteButton button: UIButton) {
        let image = UIImage(named: isLiked ? "heart-white-filled" : "heart-white")
        button.setImage(image, for: .normal)
    }
    
    func setupRealmObserver(tableView: UITableView) {
        let realm = try! Realm()
        let results = realm.objects(MusicVideo.self)
        
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
