//
//  PhotoDto.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let id: UInt
    let comments: Int
    let downloads: Int
    let likes: Int
    let largeImageURL: String
    let imageURL: String?
    let previewURL: String?
    let webformatURL: String?
    let tags: String
    let user: String
}
