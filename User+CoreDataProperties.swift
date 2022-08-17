//
//  User+CoreDataProperties.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 15/08/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String
    @NSManaged public var name: String
    @NSManaged public var webSite: String
    @NSManaged public var phone: String
    @NSManaged public var id: String

}

extension User : Identifiable {

}
