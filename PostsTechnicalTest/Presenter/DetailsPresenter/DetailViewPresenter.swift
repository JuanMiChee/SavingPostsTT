//
//  UserPresenter.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 10/08/22.
//

import Foundation
import UIKit

class DetailViewPresenter: DetailPresenter {
    
    var view: DetailView?
    
    private let fetchData: FetchDataProtocol
    private let storage: Storage
    
    init(fetchData: FetchDataProtocol, fetchCoreData: Storage){
        self.storage = fetchCoreData
        self.fetchData = fetchData
    }
    
    func handleViewDidLoad(postId: String, userId: String){
        fetchComments(postId: postId)
        fetchUser(userId: userId)
    }
    
    func handleFavorites(post: PostViewModel, comments: [CommentViewModel], user: UserViewModel, isFavorite: Bool) {
        storage.savePostViewModel(post: post)
        storage.saveCommentsAndUsers(comments: comments, user: user)
    }
    
    private func fetchComments(postId: String){
        let detailBaseUrl = URL(string: "https://jsonplaceholder.typicode.com/posts/\(String(postId))/comments")
        
        fetchData.fetchCommentsFromServer(url: detailBaseUrl!){ result in
            switch result{
            case .success(let models):
                
                let ViewModelMapped: [CommentViewModel] = models.map { (commetModel) -> CommentViewModel in
                    return CommentViewModel(postId: commetModel.postId,
                                            id: commetModel.id,
                                            body: commetModel.body)
                }
                
                self.view?.display(result: ViewModelMapped)
                
                
            case .failure(_):
                self.view?.displayAlert(message: "Error: Data not founded")
            }
        }
    }
    
    private func createUserViewModel() -> UserViewModel{
        let storedUser = storage.fetchUser()
        let coreDataViewModelMaped = UserViewModel(name: storedUser!.name,
                                                   email: storedUser!.email,
                                                   phone: storedUser!.phone,
                                                   website: storedUser!.website,
                                                   id: storedUser!.id)
        return coreDataViewModelMaped
    }
    
    private func createCommentViewModel() -> [CommentViewModel]{
        let storedUser = storage.fetchComments()
        let coreDataViewModelMaped: [CommentViewModel] = storedUser.map { (commentModel) -> CommentViewModel in
            return CommentViewModel(postId: commentModel.postId,
                                    id: commentModel.id,
                                    body: commentModel.body)
        }
        return coreDataViewModelMaped
    }
    
    private func fetchUser(userId: String){
        let userBaseUrl = URL(string: "https://jsonplaceholder.typicode.com/users/\(String(userId))")
        
        fetchData.fetchUserFromServer(url: userBaseUrl!){ result in
            switch result{
            
            case .success(let models):
                let viewModels = UserViewModel(name: models.name,
                                               email: models.email,
                                               phone: models.phone,
                                               website: models.website,
                                               id: models.id)
                self.view?.display(user: viewModels, favoriteComments: self.createCommentViewModel())
                
            case .failure(_):
                self.view?.displayAlert(message: "Error: Data not founded")
                self.view?.display(user: self.createUserViewModel(), favoriteComments: self.createCommentViewModel())
                print("fallo userfetch")
            }
        }   
    }
}



