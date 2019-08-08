//
//  FaqContent.swift
//  SpartahackVI-iOS
//
//  Created by William Huynh on 8/7/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import Foundation

struct Faq: Decodable {
    let answer: String
    let display: Bool
    let id: Int
    let placement: String
    let priority: Int
    let question: String
}
