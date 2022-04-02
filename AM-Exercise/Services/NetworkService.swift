////
////  NetworkService.swift
////  AM-Exercise
////
////  Created by Aleksandr Dainiak on 02.04.2022.
////  Copyright © 2022 Michael Mavris. All rights reserved.
////
//
//import Foundation
//
//import Foundation
//
//protocol URLSessionProtocol {
//    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
//}
//
//extension URLSession: URLSessionProtocol {}
//
//protocol NetworkService {
//    func request<T: Codable>(api: BaseTarget, completion: @escaping (Result<T, Error>) -> Void)
//}
//
//final class NetworkServiceImpl: NetworkService {
//    var urlSession: URLSessionProtocol
//
//    init(urlSession: URLSessionProtocol) {
//        self.urlSession = urlSession
//    }
//
//}
//
//extension NetworkServiceImpl {
//
//    func request<T: Codable>(api: BaseTarget, completion: @escaping (Result<T, Error>) -> Void) {
//        var components = URLComponents()
//        components.scheme = api.scheme
//        components.host = api.host
//        components.port = api.port
//        components.path = api.path
//
//        guard let url = components.url else { return }
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = api.method.rawValue
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        if api.conectionType == .stub {
//            do {
//                guard let data = api.sampleData else {
//                    completion(.failure(.noData))
//                    return
//                }
//                let responseObject = try JSONDecoder().decode(T.self, from: data)
//
//                completion(.success(responseObject))
//            } catch {
//                completion(.failure(.decodingError(error)))
//            }
//
//            return
//        }
//
//        let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
//
//            if let appError = AppError(data: data, response: response, error: error) {
//                completion(.failure(appError))
//
//                return
//            }
//
//            do {
//                guard let data = data else {
//                    completion(.failure(.noData))
//                    return
//                }
//                let responseObject = try JSONDecoder().decode(T.self, from: data)
//
//                completion(.success(responseObject))
//            } catch {
//                completion(.failure(.decodingError(error)))
//            }
//        }
//        dataTask.resume()
//    }
//}
