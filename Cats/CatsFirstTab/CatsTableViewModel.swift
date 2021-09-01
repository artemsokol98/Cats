//
//  CatsTableViewModule.swift
//  Cats
//
//  Created by Артем Соколовский on 24.08.2021.
//

import Foundation

protocol CatsTableViewModelProtocol: AnyObject {
    var cats: [Cat] { get }
    func fetchCats(completion: @escaping(Result<Void, Error>) -> Void)
    func numberOfRows() -> Int
    func numberOfSections() -> Int
}

class CatsTableViewModel: CatsTableViewModelProtocol {
    var cats: [Cat] = []
    
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
    
    func numberOfSections() -> Int {
        1 
    }
    
    func numberOfRows() -> Int {
        cats.count / 2
    }

}
