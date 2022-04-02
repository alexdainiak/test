//
//  Photo.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let comments: Int
    let downloads: Int
    let likes: Int
    let largeImageURL: String
    let tags: String
}
