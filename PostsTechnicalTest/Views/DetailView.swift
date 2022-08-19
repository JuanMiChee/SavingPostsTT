//
//  DetailView.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 18/08/22.
//

import Foundation

protocol DetailView {
    func display(result:[CommentViewModel])
    func display(user: UserViewModel, favoriteComments: [CommentViewModel])
    func displayAlert(message: String)
}
