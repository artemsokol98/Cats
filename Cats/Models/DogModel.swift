//
//  DogModel.swift
//  Cats
//
//  Created by Артем Соколовский on 26.08.2021.
//

import Foundation

struct Dog: Decodable {
    let message: [String]
}

struct DogImage: Decodable {
    let message: String
}

struct DogDetail: Decodable {
    let breed: String
    let url: String
}
