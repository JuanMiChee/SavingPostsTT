//
//  Model.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 9/08/22.
//

import Foundation
struct PostModel: Hashable {
    var isFavorite: Bool
    var userId: String
    var id: String
    var title: String
    var body: String
}
