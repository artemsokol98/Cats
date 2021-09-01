//
//  CatsAndDogsCache+CoreDataProperties.swift
//  Cats
//
//  Created by Артем Соколовский on 24.08.2021.
//
//

import Foundation
import CoreData

extension CatsAndDogsCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatsAndDogsCache> {
        return NSFetchRequest<CatsAndDogsCache>(entityName: "CatsAndDogsCache")
    }

    @NSManaged public var name: String?
    @NSManaged public var lifeSpan: String?
    @NSManaged public var origin: String?
    @NSManaged public var describe: String?
    @NSManaged public var url: String?
    @NSManaged public var date: Date?

}

extension CatsAndDogsCache: Identifiable {

}
