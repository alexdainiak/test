//
//  PhotoRepository.swift
//  AM-Exercise
//
//  Created by Aleksandr Dainiak on 02.04.2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import Foundation

protocol PhotoRepository {
    func getPhotos(completion: @escaping (Result<[Photo], Error>) -> Void)
}
