//
//  NetworkManager.swift
//  Cats
//
//  Created by Артем Соколовский on 25.06.2021.
//

import Foundation
import UIKit
import CoreData

class NetworkManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var catsCache = [CatsAndDogsCache]()
    private var dogsCache = [DogsCache]()
    private var imageCache = [ImageCache]()
    
    let sessionConfig = URLSessionConfiguration.default
    
    static let shared = NetworkManager()
    
    let urlBase = "https://api.thecatapi.com/v1/breeds"
    let apiKey = "?x-api-key=fb56469e-374c-42e8-92c5-10119d8dc403&limit=12"
    
    func entityIsEmpty(entity: String) -> Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let count = try context.count(for: request)
            return count == 0
        } catch let error as NSError {
            // failure
            print("Error: \(error.debugDescription)")
            return true
        }
    }
    
    func dateCheck() -> Bool {
        do {
            catsCache = try context.fetch(CatsAndDogsCache.fetchRequest())
            if catsCache.first?.date?.timeIntervalSinceNow ?? -86401 < -86400 {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    func createItemCat(item: Cat) {
        let newItem = CatsAndDogsCache(context: context)
        newItem.name = item.name
        newItem.origin = item.origin
        newItem.lifeSpan = item.lifeSpan
        newItem.describe = item.description
        newItem.date = Date()
        newItem.url = item.image.url
        
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func createItemDog(item: String) {
        let newItem = DogsCache(context: context)
        newItem.name = item
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func fetchCats(completion: @escaping (Result<[Cat], Error>) -> Void) {
        
        if entityIsEmpty(entity: "CatsAndDogsCache") || dateCheck() {
            print("try download from Network Cats")
            sessionConfig.timeoutIntervalForRequest = 10
            let session = URLSession(configuration: sessionConfig)
            guard let url = URL(string: urlBase + apiKey) else { return }
            
            session.dataTask(with: url) { data, _, error in
                
                if error == nil, let data = data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let cats = try? decoder.decode([Cat].self, from: data) else { return }
    
                    completion(.success(cats))
                    for item in 0..<cats.count {
                        self.createItemCat(item: cats[item])
                    }
                } else {
                    if let error = error {
                        completion(.failure(error))
                    }
                    
                }
            
            }.resume()
            
        } else {
            do {
                print("try load info from CoreData Cats")
                catsCache = try context.fetch(CatsAndDogsCache.fetchRequest())
                var downloadFromCache: [Cat] = []

                for item in 0..<catsCache.count {
                    downloadFromCache.append(
                        Cat(
                            name: catsCache[item].name ?? "",
                            lifeSpan: catsCache[item].lifeSpan ?? "",
                            origin: catsCache[item].origin ?? "",
                            image: Image(
                                url: catsCache[item].url ?? ""
                            ),
                            description: catsCache[item].describe ?? "")
                    )
                }
                completion(.success(downloadFromCache))
            } catch {
                
            }
        }
    }
    
    func fetchImage(urlImage: String) -> Data? {
        var data: Data?
        do {
            imageCache = try context.fetch(ImageCache.fetchRequest())
            if imageCache.contains(where: {_ in
                for item in 0..<imageCache.count where imageCache[item].url == urlImage {
                    return true
                }
                return false
            }) {
                let request = ImageCache.fetchRequest() as NSFetchRequest<ImageCache>
                let pred = NSPredicate(format: "url LIKE %@", urlImage)
                request.predicate = pred
                
                imageCache = try context.fetch(request)
                if let item = imageCache.first?.image {
                    data = item
                }
            } else {
                guard let url = URL(string: urlImage) else { return nil }
                guard let imageData = try? Data(contentsOf: url) else { return nil }
                
                let newItem = ImageCache(context: self.context)
                newItem.url = urlImage
                newItem.image = imageData
                newItem.date = Date()
                data = imageData
                
                do {
                    try context.save()
                } catch {
                    
                }
            }
        } catch {
            print(error)
        }
        return data
    }
    
    func fetchDetailsOfCats(breedURL: String, completion: @escaping (Result<[CatDetails], Error>) -> Void) {
        
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        guard let url = URL(string: breedURL) else { return }
        
        session.dataTask(with: url) { data, _, error in
            
            if error == nil, let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let cats = try? decoder.decode([CatDetails].self, from: data) else { return }
                print(cats)
                completion(.success(cats))
            } else {
                completion(.failure(error!))
            }

        }.resume()
        
    }
    
    func fetchDogs(url: String, completion: @escaping (Result<[String], Error>) -> Void) {
        if entityIsEmpty(entity: "DogsCache") || dateCheck() {
            print("try download from Network Dogs")
            sessionConfig.timeoutIntervalForRequest = 10
            let session = URLSession(configuration: sessionConfig)
            guard let urlString = URL(string: url) else { return }
            
            session.dataTask(with: urlString) { data, _, error in
                if error == nil, let data = data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let dogs = try? decoder.decode(Dog.self, from: data) else { return }
                    completion(.success(dogs.message))
                    for item in 0..<dogs.message.count {
                        self.createItemDog(item: dogs.message[item])
                    }
                } else {
                    if let error = error {
                        completion(.failure(error))
                    }
                }
            }.resume()
        } else {
            do {
                print("try load info from CoreData Dogs")
                dogsCache = try context.fetch(DogsCache.fetchRequest())
                var downloadFromCache: [String] = []

                for item in 0..<catsCache.count {
                    downloadFromCache.append(
                        dogsCache[item].name ?? ""
                    )
                }
                completion(.success(downloadFromCache))
            } catch {
                
            }
        }
        
    }
    
    func fetchDogsWithoutCaching(url: String, completion: @escaping (Result<[String], Error>) -> Void) {
        print("try download from Network Dogs")
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        guard let urlString = URL(string: url) else { return }
        
        session.dataTask(with: urlString) { data, _, error in
            if error == nil, let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let dogs = try? decoder.decode(Dog.self, from: data) else { return }
                completion(.success(dogs.message))
            } else {
                if let error = error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchDogsDetails(url: String, completion: @escaping (Result<DogImage, Error>) -> Void) {
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        guard let url = URL(string: url) else { return }
        
        session.dataTask(with: url) { data, _, error in
            if error == nil, let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let dogs = try? decoder.decode(DogImage.self, from: data) else {
                    return
                }
                completion(.success(dogs))
            } else {
                completion(.failure(error!))
            }
        }.resume()
    }
    
    func fetchStarWars(searchString: String, completion: @escaping (Result<StarWarsArray, Error>) -> Void) {
        
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        
        guard let url = URL(string: searchString) else { return }
    
        session.dataTask(with: url) { data, _, error in
            
            if error == nil, let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let starWarsPeople = try? decoder.decode(StarWarsArray.self, from: data) else { return }
                completion(.success(starWarsPeople))
            } else {
                completion(.failure(error!))
            }
 
        }.resume()
        
    }
    
}
