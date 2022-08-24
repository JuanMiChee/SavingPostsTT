//
//  Post+CoreDataProperties.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 15/08/22.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var title: String
    @NSManaged public var postDesctiption: String
    @NSManaged public var userId: String
    @NSManaged public var id: String
    @NSManaged public var isFavorite: Bool



}

extension Post : Identifiable {

}
