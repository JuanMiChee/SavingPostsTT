//
//  Storage.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 16/08/22.
//

import Foundation
import CoreData
import UIKit

protocol Storage{
    func fetchPosts() -> Set<PostModel>
    func fetchUser() -> UserPostsModel?
    func fetchComments() -> [CommetModel]
    func saveCommentsAndUsers(comments: [CommentViewModel], user: UserViewModel)
    func savePostViewModel(post: PostViewModel)
    func savePostModel(post: PostModel)
}

class CoreDataStorage: Storage {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchComments() -> [CommetModel] {
        do{
            let fetchRequest: NSFetchRequest<Comment> = Comment.fetchRequest()
            let savedComments: [Comment] = try self.context.fetch(fetchRequest)
            let mappedCommentModels = savedComments.map { (comment) in
                return CommetModel(postId: comment.postId, id: comment.id, body: comment.body)
            }
            return mappedCommentModels
        }catch{
            print("error fetching data")
            return []
        }
    }
    
    func fetchUser() -> UserPostsModel? {
        do{
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.fetchLimit = 1
            
            let savedUsers: [User] = try self.context.fetch(fetchRequest)
            
            if let savedUser: User = savedUsers.first {
                let mappedUserModel = UserPostsModel(name: savedUser.name, email: savedUser.email, phone: savedUser.phone, website: savedUser.webSite, id: savedUser.id)
                return mappedUserModel
            }else{
                return nil
            }
        }catch{
            print("error fetching data")
            return UserPostsModel(name: "", email: "", phone: "", website: "", id: "")
        }
    }    
    
    func fetchPosts() -> Set<PostModel> {
        do {
            let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
            let savedPosts: [Post] = try self.context.fetch(fetchRequest)
            let mappedPostModels = savedPosts.map { (post) in
                return PostModel(isFavorite: post.isFavorite,
                                 userId: post.userId,
                                 id: post.id,
                                 title: post.title,
                                 body: post.postDesctiption)
            }
            return Set(mappedPostModels)
            
        }catch{
            print("Error fetching data")
            return []
        }
    }
    
    func saveCommentsAndUsers(comments: [CommentViewModel], user: UserViewModel){
        let newUser = User(context: context)
        newUser.name = user.name
        newUser.phone = user.phone
        newUser.webSite = user.website
        newUser.email = user.email
        newUser.id = user.id
        
        comments.forEach({ (comment) in
            let newComent = Comment(context: context)
            newComent.body = comment.body
            newComent.postId = comment.postId
            newComent.id = comment.id
        })
    }
    
    func savePostViewModel(post: PostViewModel){
        let newPost = Post(context: context)
        newPost.title = post.title
        newPost.postDesctiption = post.body
        newPost.userId =  post.userId
        newPost.id = post.id
        newPost.isFavorite = post.isFavorite
        
        
        
        do {
            try CoreDataStorage().context.save()
        }
        catch{
            print("error\(error)")
        }
    }
    
    func savePostModel(post: PostModel){
        let newPost = Post(context: context)
        newPost.title = post.title
        newPost.postDesctiption = post.body
        newPost.userId =  post.userId
        newPost.id = post.id
        newPost.isFavorite = post.isFavorite
        
        
        
        do {
            try CoreDataStorage().context.save()
        }
        catch{
            print("error\(error)")
        }
    }
}

