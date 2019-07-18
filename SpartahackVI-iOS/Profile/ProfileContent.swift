//
//  ProfileContent.swift
//  SpartahackVI-iOS
//
//  Created by William Huynh on 7/17/19.
//  Copyright © 2019 wi2. All rights reserved.
//

struct Profile: Decodable {
    let role: String
    let checked_in: Bool
    let first_name: String
    let last_name: String
    let email: String
    let id: Int
    let dietary_restrictions: String
}
