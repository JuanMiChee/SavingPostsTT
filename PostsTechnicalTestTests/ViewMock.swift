//
//  ViewMock.swift
//  PostsTechnicalTestTests
//
//  Created by Juan Harrington on 17/08/22.
//

import Foundation
@testable import PostsTechnicalTest

class MockView: View{
    
    var recivedArray: [PostViewModel]?
    var recivedAlert: String?
    var recivedFavoritesArray: [PostViewModel]?
    
    func display(result: [PostViewModel], favorites: [PostViewModel]) {
        recivedArray = result
        recivedFavoritesArray = favorites
    }
    
    func displayAlert(message: String) {
        recivedAlert = message
    }
}
