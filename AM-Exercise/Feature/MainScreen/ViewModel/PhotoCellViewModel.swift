//
//  PhotoCellViewModel.swift
//  AM-Exercise
//
//  Created by Aleksandr Dainiak on 03.04.2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoCellViewModelProtocol {
    var labelText: String? { get }
    var descriptionText: String? { get }
    func cancelTask()
    func setImage(on urlString: String, completion: @escaping (UIImage?) -> Void)
}

final class PhotoCellViewModel: PhotoCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var labelText: String?
    var descriptionText: String?

    // MARK: - Private properties
    
    private var task: URLSessionDataTask?
    private var imageUrl: String?
    private var networkClient: NetworkClientProtocol?
    
    init(photo: Photo, networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
        imageUrl = photo.previewURL ?? photo.largeImageURL
        labelText =  "Author: \n\(photo.user)"
        descriptionText = "Photo ID:\n\(photo.id)"
    }
    
    // MARK: - Public methods
    
    func setImage(on urlString: String, completion: @escaping (UIImage?) -> Void) {
        if task == nil {
            task = networkClient?.fetchImage(on: urlString) { [weak self] result in
                guard
                    let self = self,
                    self.imageUrl == urlString
                else { return }
                
                switch result {
                case .success(let image):
                    completion(image)
                case .failure:
                    completion(nil)
                }
            }
        }
    }
    
    func cancelTask() {
        task?.cancel()
        task = nil
    }
}
