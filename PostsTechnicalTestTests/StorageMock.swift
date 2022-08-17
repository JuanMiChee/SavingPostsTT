//
//  StorageMock.swift
//  PostsTechnicalTestTests
//
//  Created by Juan Harrington on 17/08/22.
//

import Foundation
@testable import PostsTechnicalTest
class StorageMock: Storage {
    
    var postModel = [PostModel]()
    var userModel = UserPostsModel(name: "", email: "", phone: "", website: "", id: "")
    var commentModel = [CommetModel]()

    var recivedPosts: PostModel!
    var recivedComments: [CommetModel]!

    var recivedUser: UserViewModel!

    
    func fetchPosts() -> [PostModel] {
        return postModel
    }
    
    func fetchUser() -> UserPostsModel? {
        return userModel
    }
    
    func fetchComments() -> [CommetModel] {
        return commentModel
    }
    
    func savePost(post: PostViewModel, comments: [CommentViewModel], user: UserViewModel) {
//        recivedPosts = post
//        recivedComments = comments
//        recivedUser = user
    }
}
