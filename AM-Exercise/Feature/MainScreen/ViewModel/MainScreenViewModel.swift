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
    var page: Int { get set }
    var showAlert: ((String) -> Void)? { get set }
    var updateView: (() -> Void)? { get set }
    func loadPhotos()
}

final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    // MARK: - Public properties
    
    var showAlert: ((String) -> Void)?
    var updateView: (() -> Void)?
    var photos: [Photo] = []
    var page: Int = 1
    
    // MARK: - Private properties
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public methods
    
    func loadPhotos() {
        networkClient.fetchImages(for: "ball", page: page) { [weak self] result in
            guard let self = self else { return }
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
