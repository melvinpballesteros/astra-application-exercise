//
//  SeriesRepository.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/3/23.
//

import Foundation


class SeriesRepository {
    
    let realm = RealmManager.shared
    static let shared = SeriesRepository()
    private init() {}
    
    func getAllSeries() -> [Series] {
        let item = realm.getAll(Series())
        return [Series] (item)
    }
    
    func create(_ object: Series) {
        let obj = Series(trackId: object.trackId, 
                         title: object.title, 
                         type: object.type,
                         poster: object.poster, 
                         isFavorite: object.isFavorite)
        realm.create(obj)
    }
    
    func create(_ series: [Series]) {
        realm.create(series)
    }
    
    func delete(_ id: String) {
        if let obj = realm.getAll(Series()).filter({$0.trackId == id}).first {
            realm.delete(obj)
        }
    }
    
    func deleteAll() {
        let results = realm.getAll(Series())
        realm.delete(results)
    }
    
    func updateFavorite(_ oldSeries: Series, newSeries: Series) {
        realm.update(oldSeries, with: ["isFavorite": newSeries.isFavorite])
    }
    
    func isFavoriteSeries(_ series: Series) -> Bool {
        if let object = realm.getAll(Series()).filter({$0.trackId == series.trackId}).first {
            return object.isFavorite
        } else {
            return false
        }
    }
    
    func search(_ text: String) -> [Series] {
        let objects = realm.getAll(Series())
        let predicate = NSPredicate(format: "(title contains[cd] %@) OR (type contains[cd] %@)", text, text)
        let results = [Series] (objects.filter(predicate))
        if results.count > 0 {
            return results
        } else {
            return getAllSeries()
        }
    }
    
}
