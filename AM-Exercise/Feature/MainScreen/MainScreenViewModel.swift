//
//  MainScreenViewModel.swift
//  AM-Exercise
//
//  Created by Aleksandr Dainiak on 02.04.2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//
import Foundation

protocol MainScreenViewModelProtocol {
    var photos: [Photo] { get }
    var showAlert: ((String) -> Void)? { get set }
    var updateView: (() -> Void)? { get set }
    func loadPhotos()
}

final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    // MARK: - Public properties
    
    var showAlert: ((String) -> Void)?
    var updateView: (() -> Void)?
    var photos: [Photo] = []
    
    var handleDataCallback: ((Result<[Photo], Error>) -> Void)!
    
    // MARK: - Private properties
    
    //    private let photoRepository: PhotoRepository
    //
    //    init(photoRepository: PhotoRepository) {
    //        self.photoRepository = photoRepository
    //    }
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public methods
    
    func loadPhotos() {
        networkClient.fetchImages(for: "ball") { [unowned self] result in
            
            switch result {
            case .success(let downLoadedPhotos):
                self.photos.append(contentsOf: downLoadedPhotos)
                self.updateView?()
            case .failure(let error):
                self.showAlert?(error.localizedDescription)
            }
        }
    }
}
