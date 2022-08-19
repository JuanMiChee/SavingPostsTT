//
//  View.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 9/08/22.
//

import Foundation


protocol View: AnyObject {
    func display(result:[PostViewModel], favorites: [PostViewModel])
    func displayAlert(message: String)
}

struct PostViewModel {
    var userId: String
    var id: String
    var title: String
    var body: String
}

struct CommentViewModel {
    var postId: String
    var id: String
    var body: String
}

struct UserViewModel {
    var name: String
    var email: String
    var phone: String
    var website: String
    var id: String
}
