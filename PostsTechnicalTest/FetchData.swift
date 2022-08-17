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
    func fetchPostsFromServer(url: URL, completion: @escaping (Result<[PostModel], FetchError>) -> Void)
    func fetchPosts(url: URL, completion: @escaping (Result<[CommetModel], FetchError>) -> Void)
    func userFetchDataFromServer(url: URL, completion: @escaping (Result<UserPostsModel, FetchError>) -> Void)
}


class FetchData: FetchDataProtocol{
    
    func userFetchDataFromServer(url: URL, completion: @escaping (Result<UserPostsModel, FetchError>) -> Void) {
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
                    completion(.success(userPost))
                
                
            
            } else {
                print("Error \(response.statusCode)")
                completion(.failure(.networkError(errormessage: error?.localizedDescription ?? "nil")))
            }
        }.resume()
    }
    
    
    func fetchPosts(url: URL, completion: @escaping (Result<[CommetModel], FetchError>) -> Void) {
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
                    
                    completion(.success(viewModels))
                
                
            }
            if response.statusCode == 200 {
                print("200")
            } else {
                print("Error \(response.statusCode)")
            }
        }.resume()
    }
    
    
    
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchPostsFromServer(url: URL, completion: @escaping (Result<[PostModel], FetchError>) -> Void) {
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
                        
                        return PostModel(userId: String(postsJSON.userId),
                                         id: String(postsJSON.id),
                                         title: postsJSON.title,
                                         body: postsJSON.body)
                        
                    }
                    
                    completion(.success(viewModels))
                
                
            }
            if response.statusCode == 200 {
                print("200")
            } else {
                print("Error \(response.statusCode)")
            }
        }.resume()
    }
    
}
