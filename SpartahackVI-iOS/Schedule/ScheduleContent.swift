//
//  ScheduleContent.swift
//  SpartahackVI-iOS
//
//  Created by William Huynh on 7/16/19.
//  Copyright © 2019 wi2. All rights reserved.
//

struct Schedule: Decodable {
    let description: String
    let id: Int
    let location: String
    let time: String
    let title: String
    let updated_at: String
}
