//
//  Comment+CoreDataProperties.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 15/08/22.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var body: String
    @NSManaged public var id: String
    @NSManaged public var postId: String

}

extension Comment : Identifiable {

}
