//
//  DataManager.swift
//  Cats
//
//  Created by Артем Соколовский on 19.07.2021.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    var lastSearches: [String] = []
    
    var starWarsPeople: [StarWarsPeople] = []
    
    private init() {}
}
