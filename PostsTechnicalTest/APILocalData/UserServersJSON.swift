//
//  UserServersJSON.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 10/08/22.
//

import Foundation

struct UserServersJSON: Decodable {
    let name: String 
    let email: String
    let phone: String
    let website: String
    let id: Int
}
