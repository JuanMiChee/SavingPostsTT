//
//  ViewPresenter.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 9/08/22.
//

import Foundation
import UIKit
import CoreData

class MainViewPresenter: MainPresenter {
    
    private let baseUrl = URL(string: "https://jsonplaceholder.typicode.com/posts")
    weak var view: View?
    
    private let fetchData: FetchDataProtocol
    private let storage: Storage

    init(fetchData: FetchDataProtocol, fetchCoreData: Storage){
        self.storage = fetchCoreData
        self.fetchData = fetchData
    }
    
    private func createStoragePostViewModel() -> [PostViewModel]{
        let storedPosts = storage.fetchPosts()
        let coredataViewModelMapped: [PostViewModel] = storedPosts.map { (postModel) -> PostViewModel in
            return PostViewModel(isFavorite: postModel.isFavorite,
                                 userId: postModel.userId,
                                 id: postModel.id,
                                 title: postModel.title,
                                 body: postModel.body)
        }
        return coredataViewModelMapped
    }
    
    
    func handleViewDidLoad(){
        fetchData.fetchPostsFromServer(url: baseUrl!){ result in
            switch result{
            case .success(let models):
                
                let storedPosts: Set = self.storage.fetchPosts()
                let nonRepeatedPosts = storedPosts.symmetricDifference(models)
                nonRepeatedPosts.forEach { (post) in
                    self.storage.savePostModel(post: post)
                }
                
                let ViewModelMapped: [PostViewModel] = models.map { (postModel: PostModel) -> PostViewModel in
                    return PostViewModel(isFavorite: postModel.isFavorite,
                                         userId: postModel.userId,
                                         id: postModel.id,
                                         title: postModel.title,
                                         body: postModel.body)
                }
                
                self.view?.display(result: self.createStoragePostViewModel())//ViewModelMapped)//, favorites: self.createStoragePostViewModel())
            case .failure(_):
                self.view?.display(result: self.createStoragePostViewModel())
                self.view?.displayAlert(message: "couldn't find data, sending coredata favorites")
                
            }
        }
    }
}


