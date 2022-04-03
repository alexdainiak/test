////
////  PhotoRepository.swift
////  AM-Exercise
////
////  Created by Aleksandr Dainiak on 02.04.2022.
////  Copyright © 2022 Michael Mavris. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//final class PhotoRepositoryImpl: PhotoRepository {
//    
//    
//    let networkClient: NetworkClientProtocol
//    init(networkClient: NetworkClientProtocol) {
//        self.networkClient = networkClient
//    }
//    
//    func fetchImages(for string: String, page: Int ,completion: @escaping (Result<[Photo], Error>) -> Void) {
//        netorkService.request(api: MainScreenTarget.getRecipes) { (result: Result<[RecipeDto], AppError>) in
//            completion(result.map { $0 })
//        }
//    }
//    
//    
//    func fetchImage(on urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask? {
//        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
//            completion(.success(imageFromCache))
//            return nil
//        }
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(.general))
//            return nil
//        }
//        
//        let task = urlSession.dataTask(with: url) { (jsonData, response, error) in
//            
//            if let error = error {
//                completion(.failure(.network(error: error, response: response)))
//            }
//            
//            if let image = jsonData.flatMap(UIImage.init(data:)) {
//                imageCache.setObject(image, forKey: urlString as NSString)
//                completion(.success(image))
//            } else {
//                let decodingError = NSError(domain: "com.exercise.AM-Exercise", code: -1, userInfo: nil)
//                completion(.failure(.parsing(error: decodingError)))
//            }
//        }
//        task.resume()
//        
//        return task
//    }
//}
