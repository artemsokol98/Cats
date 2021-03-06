//
//  NetworkManager.swift
//  Cats
//
//  Created by Артем Соколовский on 25.06.2021.
//

import Foundation

enum ObtainResultCat {
    case success(cats: [Cat])
    case failure(error: Error)
}

enum ObtainResultStarWars {
    case success(sw: StarWarsArray)
    case failure(error: Error)
}

class NetworkManager {
    
    let sessionConfig = URLSessionConfiguration.default
    
    static let shared = NetworkManager()
    
    let urlBase = "https://api.thecatapi.com/v1/breeds"
    let api_key = "?x-api-key=fb56469e-374c-42e8-92c5-10119d8dc403&limit=12"
    
    let urlStarWars = "https://swapi.dev/api/people/?search="
    
    func fetchCats(completion: @escaping (ObtainResultCat) -> Void) {
        
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        guard let url = URL(string: urlBase + api_key) else { return }
        
        session.dataTask(with: url) { data, response, error in
            var result: ObtainResultCat
            
            if error == nil, let data = data {
                
                guard let cats = try? JSONDecoder().decode([Cat].self, from: data) else { return }
                print(cats)
                result = .success(cats: cats)
            } else {
                result = .failure(error: error!)
            }
            
            completion(result)
            
        }.resume()
        
    }
    
    func fetchImage(urlImage: String) -> Data? {
        guard let url = URL(string: urlImage) else { return nil }
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        
        return imageData
        
    }
    
    func fetchStarWars(searchString: String, completion: @escaping (ObtainResultStarWars) -> Void) {
        
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        
        guard let url = URL(string: searchString) else { return }
        print(url)
        session.dataTask(with: url) { data, response, error in
            var result: ObtainResultStarWars
            
            if error == nil, let data = data {
                
                guard let starWarsPeople = try? JSONDecoder().decode(StarWarsArray.self, from: data) else { return }
                print(starWarsPeople)
                result = .success(sw: starWarsPeople)
            } else {
                result = .failure(error: error!)
            }
            
            completion(result)
            
        }.resume()
        
    }
    
}

