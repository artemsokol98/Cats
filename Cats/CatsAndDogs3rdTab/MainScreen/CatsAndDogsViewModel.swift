//
//  CatsAndDogsViewModel.swift
//  Cats
//
//  Created by Артем Соколовский on 30.08.2021.
//

import Foundation

protocol CatsAndDogsViewModelProtocol: AnyObject {
    var cats: [Cat] { get }
    var dogs: [String] { get }
    var dogDetail: [DogDetail] { get }
    func fetchCats(completion: @escaping(Result<Void, Error>) -> Void)
    func fetchDogsListBreeds(completion: @escaping(Result<Void, Error>) -> Void)
    func fetchDogsDetails(breed: String, completion: @escaping(Result<Void, Error>) -> Void)
    func getData(completion: @escaping (Result<Void, Error>) -> Void)
}

class CatsAndDogsViewModel: CatsAndDogsViewModelProtocol {

    let mainGroup = DispatchGroup()
    
    func getData(completion: @escaping (Result<Void, Error>) -> Void) {
        let refreshQueue = DispatchQueue.global(qos: .userInitiated)
        
        mainGroup.enter()
        refreshQueue.async(group: mainGroup) { [weak self] in
            guard let self = self else { return }
            self.fetchCats { _ in
                self.mainGroup.leave()
                print(self.cats)
            }
            
        }
        mainGroup.enter()
        refreshQueue.async(group: mainGroup) { [weak self] in
            guard let self = self else { return }
            self.fetchDogsListBreeds { result in
                switch result {
                case .success(()):
                    
                    for item in 0..<12 {
                        self.mainGroup.enter()
                        refreshQueue.async(group: self.mainGroup) { [weak self] in
                            guard let self = self else { return }
                            
                            self.fetchDogsDetails(breed: self.dogs[item]) { _ in
                                self.mainGroup.leave()
                            }
                            
                        }
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                    
                }
                self.mainGroup.leave()
            }
            
            print(self.dogs)
        }
        
        mainGroup.notify(queue: .main) {
            completion(.success(()))
            self.addGeneralArray()
        }
    }
    
    func addGeneralArray() {
        for firstItem in 0..<2 {
            for item in 0..<6 {
                if firstItem == 0 {
                    DataManager.shared.dogsAndCats.append(CatsAndDogs(
                        breed: cats[item].name,
                        url: cats[item].image.url)
                    )
                } else {
                    DataManager.shared.dogsAndCats.append(CatsAndDogs(
                        breed: dogDetail[item].breed,
                        url: dogDetail[item].url)
                    )
                }
            }
        }
    }
    
    private let listOfBreedsDogs = "https://dog.ceo/api/breeds/list"
    
    func getImagesOfBreed(breed: String) -> String {
        "https://dog.ceo/api/breed/\(breed)/images/random"
    }
    
    var dogDetail: [DogDetail] = []
    
    var cats: [Cat] = []
    
    var dogs: [String] = []
    
    func fetchCats(completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.fetchCats { result in
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
    
    func fetchDogsListBreeds(completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.fetchDogs(url: listOfBreedsDogs) { result in
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
    
    func fetchDogsDetails(breed: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = getImagesOfBreed(breed: breed)
        NetworkManager.shared.fetchDogsDetails(url: url) { result in
            switch result {
            case .success(let dogImage):
                DispatchQueue.main.async {
                    print("breed \(breed)")
                    self.dogDetail.append(DogDetail(breed: breed, url: dogImage.message))
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
