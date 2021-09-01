//
//  CatsAndDogsDetailsViewModel.swift
//  Cats
//
//  Created by Артем Соколовский on 31.08.2021.
//

import Foundation

protocol CatsAndDogsDetailsViewModelProtocol: AnyObject {
    var cats: [CatDetails] { get }
    var dogs: [String] { get }
    func fetchCats(breed: String, completion: @escaping(Result<Void, Error>) -> Void)
    func fetchDogs(breed: String, completion: @escaping(Result<Void, Error>) -> Void)
    func getData(index: Int, breed: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class CatsAndDogsDetailsViewModel: CatsAndDogsDetailsViewModelProtocol {
    
    func getData(index: Int, breed: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if index < 6 {
            self.fetchCats(breed: breed) { result in
                switch result {
                case .success(()):
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            self.fetchDogs(breed: breed) { result in
                switch result {
                case .success(()):
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    var cats: [CatDetails] = []
    
    var dogs: [String] = []
    
    func getImagesOfBreed(breed: String) -> String {
        "https://dog.ceo/api/breed/\(breed)/images"
    }
    
    let imagesOfBreedApi = "https://api.thecatapi.com/v1/images/search?limit=8&breed_ids="
    func fetchCats(breed: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = imagesOfBreedApi + breed.prefix(4)
        NetworkManager.shared.fetchDetailsOfCats(breedURL: url) { result in
            switch result {
            case .success(let cats):
                DispatchQueue.main.async {
                    self.cats = cats
                    completion(.success(()))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchDogs(breed: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = getImagesOfBreed(breed: breed)
        NetworkManager.shared.fetchDogsWithoutCaching(url: url) { result in
            switch result {
            case .success(let dogs):
                DispatchQueue.main.async {
                    self.dogs = dogs
                    completion(.success(()))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
