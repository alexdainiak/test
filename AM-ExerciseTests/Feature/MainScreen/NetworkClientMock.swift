//
//  NetworkClientMock.swift
//  AM-ExerciseTests
//
//  Created by Aleksandr Dainiak on 03.04.2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

@testable import AM_Exercise
import UIKit
import Foundation

class NetworkClientMock: NetworkClientProtocol {

    let resultPhoto: Result<[Photo], NetworkClient.Error>
    let resultImage: Result<UIImage, NetworkClient.Error>
    
    init(resultPhoto: Result<[Photo], NetworkClient.Error>, resultImage: Result<UIImage, NetworkClient.Error>) {
        self.resultPhoto = resultPhoto
        self.resultImage = resultImage
    }
    
    func fetchImages(for query: String, page: Int, completion: @escaping (Result<[Photo], NetworkClient.Error>) -> Void) {
        completion(resultPhoto)
    }
    func fetchImage(on urlString: String, completion: @escaping (Result<UIImage, NetworkClient.Error>) -> Void) -> URLSessionDataTask? {
        completion(resultImage)
        return nil
    }
}
