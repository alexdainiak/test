//
//  PhotoResponse.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import Foundation
struct PhotoResponse: Decodable {
    let hits: [Photo]
    let total: Int
}
