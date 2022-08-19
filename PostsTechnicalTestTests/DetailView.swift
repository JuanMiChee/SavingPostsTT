//
//  DetailView.swift
//  PostsTechnicalTestTests
//
//  Created by Juan Harrington on 18/08/22.
//

import Foundation
@testable import PostsTechnicalTest


class DetailMockView: DetailView{
    
    var recivedAlert: String?
    var recivedResult: [CommentViewModel]?
    var recivedUser: UserViewModel?
    var recivedComments: [CommentViewModel]?
    

    func displayAlert(message: String) {
        recivedAlert = message
    }
    
    func display(result: [CommentViewModel]) {
        recivedResult = result
    }
    
    func display(user: UserViewModel, favoriteComments: [CommentViewModel]) {
        recivedUser = user
        recivedComments = favoriteComments
    }
}
