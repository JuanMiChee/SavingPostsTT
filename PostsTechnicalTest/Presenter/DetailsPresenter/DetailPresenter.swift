//
//  DetailPresenter.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 10/08/22.
//

import Foundation
import UIKit

protocol DetailPresenter {
    var view: DetailView? { get set }
    
    func handleViewDidLoad(postId: String, userId: String)
    func handleFavorites(post: PostViewModel, comments: [CommentViewModel], user: UserViewModel, isFavorite: Bool)
}
