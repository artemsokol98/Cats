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
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    let url: String
}
