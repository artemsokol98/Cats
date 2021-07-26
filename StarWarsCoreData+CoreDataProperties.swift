//
//  StarWarsCoreData+CoreDataProperties.swift
//  Cats
//
//  Created by Артем Соколовский on 22.07.2021.
//
//

import Foundation
import CoreData

extension StarWarsCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StarWarsCoreData> {
        return NSFetchRequest<StarWarsCoreData>(entityName: "StarWarsCoreData")
    }

    @NSManaged public var name: String?
    @NSManaged public var height: String?
    @NSManaged public var mass: String?
    @NSManaged public var hairColor: String?
    @NSManaged public var skinColor: String?
    @NSManaged public var eyeColor: String?
    @NSManaged public var birthYear: String?
    @NSManaged public var gender: String?

}

extension StarWarsCoreData: Identifiable {

}
