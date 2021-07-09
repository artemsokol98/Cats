//
//  StarWarsModel.swift
//  Cats
//
//  Created by Артем Соколовский on 07.07.2021.
//

import Foundation

struct StarWarsArray: Decodable {
    let next: String?
    let results: [StarWarsPeople]
}
