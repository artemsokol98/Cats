//
//  CatModel.swift
//  Cats
//
//  Created by Артем Соколовский on 25.06.2021.
//

import Foundation

struct Cat: Decodable {
    let name: String
    let life_span: String
    let origin: String
    let image: Image
    let description: String
}

struct Image: Decodable {
    let url: String
}
