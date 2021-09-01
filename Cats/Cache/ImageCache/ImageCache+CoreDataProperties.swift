//
//  ImageCache+CoreDataProperties.swift
//  Cats
//
//  Created by Артем Соколовский on 25.08.2021.
//
//

import Foundation
import CoreData

extension ImageCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageCache> {
        return NSFetchRequest<ImageCache>(entityName: "ImageCache")
    }

    @NSManaged public var date: Date?
    @NSManaged public var image: Data?
    @NSManaged public var url: String?

}

extension ImageCache: Identifiable {

}
