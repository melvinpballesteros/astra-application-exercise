//
//  MusicVideoRepository.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation

class MusicVideoRepository {
    
    let realm = RealmManager.shared
    static let shared = MusicVideoRepository()
    private init() {}
    
    func getAll() -> [MusicVideo] {
        let item = realm.getAll(MusicVideo())
        return [MusicVideo] (item)
    }
    
    func create(_ musicVideo: MusicVideo) {
        let obj = MusicVideo(trackId: musicVideo.trackId, 
                             title: musicVideo.title, 
                             price: musicVideo.price, 
                             genre: musicVideo.genre, 
                             artwork: musicVideo.artwork, 
                             previewUrl: musicVideo.previewUrl, 
                             releaseDate: musicVideo.releaseDate, 
                             isFavorite: musicVideo.isFavorite)
        realm.create(obj)
    }
    
    func create(_ musicVideos: [MusicVideo]) {
        realm.create(musicVideos)
    }
    
    func delete(_ id: Int) {
        if let obj = realm.getAll(Movie()).filter({$0.trackId == id}).first {
            realm.delete(obj)
        }
    }
    
    func updateFavorite(_ oldMusicVideo: MusicVideo, newMusicVideo: MusicVideo) {
        realm.update(oldMusicVideo, with: ["isFavorite": newMusicVideo.isFavorite])
    }
    
    func isFavoriteMovie(_ musicVideo: MusicVideo) -> Bool {
        if let object = realm.getAll(MusicVideo()).filter({$0.trackId == musicVideo.trackId}).first {
            return object.isFavorite
        } else {
            return false
        }
    }
}
