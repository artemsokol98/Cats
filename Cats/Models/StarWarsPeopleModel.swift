//
//  StarWarsPeopleModel.swift
//  Cats
//
//  Created by Артем Соколовский on 09.07.2021.
//

import Foundation

struct StarWarsPeople: Decodable {
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let url: String
}
