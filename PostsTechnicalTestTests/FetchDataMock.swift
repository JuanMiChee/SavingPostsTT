//
//  FetchDataMock.swift
//  PostsTechnicalTestTests
//
//  Created by Juan Harrington on 17/08/22.
//

import Foundation
@testable import PostsTechnicalTest

class FetchDataMock: FetchDataProtocol {
    var recivedPostsUrl: URL?
    var recivedPostsCompetion: ((Result<[PostModel], FetchError>) -> Void)?
    
    var recivedUsersUrl: URL?
    var recivedUsersCompetion: ((Result<UserPostsModel, FetchError>) -> Void)?
    
    var recivedCommentsUrl: URL?
    var recivedCommentsCompetion: ((Result<[CommetModel], FetchError>) -> Void)?
    
    func fetchPostsFromServer(url: URL, completion: @escaping (Result<[PostModel], FetchError>) -> Void) {
        recivedPostsUrl = url
        recivedPostsCompetion = completion
    }
    
    func fetchPosts(url: URL, completion: @escaping (Result<[CommetModel], FetchError>) -> Void) {
        recivedCommentsUrl = url
        recivedCommentsCompetion = completion
        
    }
    
    func userFetchDataFromServer(url: URL, completion: @escaping (Result<UserPostsModel, FetchError>) -> Void) {
        recivedUsersUrl = url
        recivedUsersCompetion = completion
    }
    
    
}
