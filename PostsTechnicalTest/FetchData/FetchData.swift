//
//  FetchData.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 9/08/22.
//

import Foundation

enum FetchError: Error {
    case networkError(errormessage: String)
}

protocol FetchDataProtocol{
    func fetchPostsFromServer(url: URL, completion: @escaping (Result<Set<PostModel>, FetchError>) -> Void)
    func fetchCommentsFromServer(url: URL, completion: @escaping (Result<[CommetModel], FetchError>) -> Void)
    func fetchUserFromServer(url: URL, completion: @escaping (Result<UserPostsModel, FetchError>) -> Void)
}

class FetchData: FetchDataProtocol{
    
    func fetchUserFromServer(url: URL, completion: @escaping (Result<UserPostsModel, FetchError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                if let error = error {
                    print("Error en la operación \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(.networkError(errormessage: error.localizedDescription)))
                    }
                    return
                }
                return
            }
            
            if let decodedJSON = try? JSONDecoder().decode(UserServersJSON.self, from: data) {
                let userPost = UserPostsModel(name: decodedJSON.name,
                                        email: decodedJSON.email,
                                        phone: decodedJSON.phone,
                                        website: decodedJSON.website,
                                        id: String(decodedJSON.id))
                DispatchQueue.main.async {
                    completion(.success(userPost))
                }
            
            } else {
                print("Error \(response.statusCode)")
                DispatchQueue.main.async {
                    completion(.failure(.networkError(errormessage: error?.localizedDescription ?? "nil")))

                }
            }
        }.resume()
    }
    
    func fetchCommentsFromServer(url: URL, completion: @escaping (Result<[CommetModel], FetchError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                if let error = error {
                    print("Error en la operación \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(.networkError(errormessage: error.localizedDescription)))
                    }
                    
                    return
                }
                return
            }
            
            if let decodedData = try? JSONDecoder().decode([DetailServeresJSON].self, from: data) {
                
                let viewModels: [CommetModel] = decodedData.map { (detailJSON: DetailServeresJSON) -> CommetModel in
                        
                        return CommetModel(postId: String(detailJSON.postId),
                                               id: String(detailJSON.id),
                                               body: detailJSON.body)
                    }
                DispatchQueue.main.async {
                    completion(.success(viewModels))

                }
            }
            if response.statusCode == 200 {
                print("200")
            } else {
                print("Error \(response.statusCode)")
            }
        }.resume()
    }

    func fetchPostsFromServer(url: URL, completion: @escaping (Result<Set<PostModel>, FetchError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                if let error = error {
                    print("Error en la operación \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(.networkError(errormessage: error.localizedDescription)))
                    }
                    
                    return
                }
                return
            }
    
            if let decodedData = try? JSONDecoder().decode([ServersJSON].self, from: data) {
                
                    let viewModels: [PostModel] = decodedData.map { (postsJSON) -> PostModel in
                        
                        return PostModel(isFavorite: false,
                                         userId: String(postsJSON.userId),
                                         id: String(postsJSON.id),
                                         title: postsJSON.title,
                                         body: postsJSON.body)
                    }
                DispatchQueue.main.async {
                    completion(.success(Set(viewModels)))
                }
            }
            if response.statusCode == 200 {
                print("200")
            } else {
                print("Error \(response.statusCode)")
            }
        }.resume()
    }
    
}
