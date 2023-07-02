//
//  ApiManager.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 6/30/23.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    private init() {}
    
    func getRequest(_ urlString: String, completion: @escaping(Data?, Error?) -> Void) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    } 
}
