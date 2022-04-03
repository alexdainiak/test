//
//  NetworkClient.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

protocol URLSessionProtocol {
     func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
     
}

extension URLSession: URLSessionProtocol {}

protocol NetworkClientProtocol {
     func fetchImages(for query: String, page: Int, completion: @escaping (Result<[Photo], NetworkClient.Error>) -> Void)
     func fetchImage(on urlString: String, completion: @escaping (Result<UIImage, NetworkClient.Error>) -> Void) -> URLSessionDataTask?
}

final class NetworkClient: NetworkClientProtocol {
     
     // MARK: - Nested enum
     
     enum Error: Swift.Error {
          case general
          case invalid(response: URLResponse?)
          case network(error: Swift.Error, response: URLResponse?)
          case parsing(error: Swift.Error)
     }
     // MARK: - Private Properties
     
     private let apiKey = "22577733-edb14e0d0f3f9c1a039c57e48"
     private let baseURL = "https://pixabay.com/api/"
     
     private var urlSession: URLSessionProtocol
     
     init(urlSession: URLSessionProtocol) {
          self.urlSession = urlSession
     }
     
     // MARK: - Public methods
     
     func fetchImages(for query: String, page: Int = 1, completion: @escaping (Result<[Photo], Error>) -> Void) {
          guard let url = URL(string: "\(baseURL)?key=\(apiKey)&q=\(query)&image_type=photo&page=\(page)&per_page=25") else {
               completion(.failure(.general))
               return
          }
          
          urlSession.dataTask(with: url) { (jsonData, response, error) in
               let result: Result<PhotoResponse, Error> = self.handleResponse(data: jsonData, error: error, response: response)
               completion(result.map { $0.hits })
               
          }.resume()
     }
     
     func fetchImage(on urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask? {
          if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
               completion(.success(imageFromCache))
               return nil
          }
          
          guard let url = URL(string: urlString) else {
               completion(.failure(.general))
               return nil
          }
          
          let task = urlSession.dataTask(with: url) { (jsonData, response, error) in
               
               if let error = error {
                    completion(.failure(.network(error: error, response: response)))
               }
               
               if let image = jsonData.flatMap(UIImage.init(data:)) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    completion(.success(image))
               } else {
                    let decodingError = NSError(domain: "com.exercise.AM-Exercise", code: -1, userInfo: nil)
                    completion(.failure(.parsing(error: decodingError)))
               }
          }
          task.resume()
          
          return task
     }
     
     // MARK: - Private methods
     
     private func handleResponse<Type: Decodable>(
          data: Data?, error: Swift.Error?, response: URLResponse?) -> Result<Type, Error> {
               if let error = error {
                    return .failure(.network(error: error, response: response))
               }
               
               if let jsonData = data {
                    do {
                         return .success(try JSONDecoder().decode(Type.self, from: jsonData))
                    } catch {
                         print("Error info: \(error)")
                         return .failure(.parsing(error: error))
                    }
               } else {
                    return .failure(.invalid(response: response))
               }
          }
}
