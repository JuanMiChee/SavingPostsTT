//
//  StorageMock.swift
//  PostsTechnicalTestTests
//
//  Created by Juan Harrington on 17/08/22.
//

import Foundation
@testable import PostsTechnicalTest
class StorageMock: Storage {
    
    var postModels = [PostModel]()
    var userModel = UserPostsModel(name: "", email: "", phone: "", website: "", id: "")
    var commentModel = [CommetModel]()

    var toSaveComments: [CommentViewModel]!
    var toSavePosts: PostViewModel!
    var toSaveUsers: UserViewModel!

    
    func fetchPosts() -> [PostModel] {
        return postModels
    }
    
    func fetchUser() -> UserPostsModel? {
        return userModel
    }
    
    func fetchComments() -> [CommetModel] {
        return commentModel
    }
    
    func savePost(post: PostViewModel, comments: [CommentViewModel], user: UserViewModel) {
        toSavePosts = post
        toSaveComments = comments
        toSaveUsers = user
    }
}
