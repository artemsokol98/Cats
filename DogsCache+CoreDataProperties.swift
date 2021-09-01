//
//  DogsCache+CoreDataProperties.swift
//  Cats
//
//  Created by Артем Соколовский on 31.08.2021.
//
//

import Foundation
import CoreData

extension DogsCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogsCache> {
        return NSFetchRequest<DogsCache>(entityName: "DogsCache")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?

}

extension DogsCache: Identifiable {

}
