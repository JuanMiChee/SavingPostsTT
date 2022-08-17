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
    private let fetchCoreData: Storage

    init(fetchData: FetchDataProtocol, fetchCoreData: Storage){
        self.fetchCoreData = fetchCoreData
        self.fetchData = fetchData
    }
    
    private func createStoragePostViewModel() -> [PostViewModel]{
        let storedPosts = fetchCoreData.fetchPosts()
        let coredataViewModelMapped: [PostViewModel] = storedPosts.map { (postModel) -> PostViewModel in
            return PostViewModel(userId: postModel.userId,
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
                
                
                let ViewModelMapped: [PostViewModel] = models.map { (postModel: PostModel) -> PostViewModel in
                    return PostViewModel(userId: postModel.userId,
                                         id: postModel.id,
                                         title: postModel.title,
                                         body: postModel.body)
                }
                
                self.view?.display(result: ViewModelMapped, favorites: self.createStoragePostViewModel())
            case .failure(_):
                self.view?.display(result: [], favorites: self.createStoragePostViewModel())
                self.view?.displayAlert(message: "couldn't find data, sending coredata favorites")
                
            }
        }
    }
}


