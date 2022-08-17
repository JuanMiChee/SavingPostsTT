//
//  DetailServersJSON.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 10/08/22.
//

import Foundation

struct DetailServeresJSON: Decodable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
