//
//  DataManager.swift
//  Cats
//
//  Created by Артем Соколовский on 19.07.2021.
//

import Foundation
import UIKit

class DataManager {
    static let shared = DataManager()
    var lastSearches: [String] = []
    var starWarsPeople: [StarWarsPeople] = []
    var singleImages: [Int: UIImage] = [:]
    var catsAndDogsCache: [CatsAndDogsCache] = []
    var dogsImagesForDetailVC: [Int: UIImage] = [:]
    
    // MARK: - for 3rd tab
    var dogsAndCats: [CatsAndDogs] = []
    private init() {}
}
