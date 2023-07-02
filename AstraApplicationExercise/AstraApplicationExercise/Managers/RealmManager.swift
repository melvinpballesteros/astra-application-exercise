//
//  RealmManager.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 6/30/23.
//

import Foundation
import RealmSwift

class RealmManager {
    
    private init() {
        let config = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: false)
        Realm.Configuration.defaultConfiguration = config
    }
    
    static let shared = RealmManager()
    
    /// Function - Select All
    func getAll<T: Object>(_ object: T) -> Results<T> {
        let realm = try! Realm()
        return realm.objects(T.self)
    }
    
    /// Function - Create
    func create<T: Object>(_ object: T) {
        let realm = try? Realm()
        do {
            try realm?.write {
                realm?.add(object)
            }
        } catch {
            print(error)
        }
    }
    
    /// Function - Mass Creation
    func create<T: Object>(_ object: [T]) {
        let realm = try? Realm()
        do {
            try realm?.write {
                realm?.add(object)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Function - Update
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]){
        let realm = try! Realm()
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Function - Delete
    func delete<T: Object>(_ object: T){
        let realm = try! Realm()
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    /// Function - Mass Deletion
    func delete<T: Object>(_ object: List<T>){
        let realm = try! Realm()
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    /// Function - Single Deletion
    func delete<T: Object>(_ object: Results<T>){
        let realm = try! Realm()
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    // FORMAT DISK
    func deleteAll(){
        let realm = try! Realm()
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch{
            print(error.localizedDescription)
        }
    }
}
