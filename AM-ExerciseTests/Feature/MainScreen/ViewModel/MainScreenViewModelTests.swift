//
//  MainScreenViewModelTests.swift
//  AM-ExerciseTests
//
//  Created by Aleksandr Dainiak on 03.04.2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//
import XCTest
@testable import AM_Exercise

class MainScreenViewModelTests: XCTestCase {
    private var mainScreenViewModel: MainScreenViewModelProtocol!
    private var networkClientMock: NetworkClientMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    override func tearDown() {
        mainScreenViewModel = nil
        super.tearDown()
    }
    
    func testSuccessfullPhotosResponce() {
        let networkClientMock = NetworkClientMock(resultPhoto: MainScreenViewModelTests.photosSuccessMock, resultImage: MainScreenViewModelTests.imageSuccessMock)
        mainScreenViewModel = MainScreenViewModel(networkClient: networkClientMock)
        var didCallShowAlert = false
        mainScreenViewModel.showAlert = { _ in
            didCallShowAlert = true
        }
        
        var didCallUpdateView = false
        mainScreenViewModel.updateView = {
            didCallUpdateView = true
        }
        
        let photosExpectation = expectation(description: "photosExpectation")
        photosExpectation.fulfill()
        mainScreenViewModel.loadPhotos()
        
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(self.mainScreenViewModel.photos.count, 1)
            XCTAssertEqual(self.mainScreenViewModel.photos.first?.user, "foo")
            XCTAssertTrue(didCallUpdateView, "Did not call viewModel.updateView")
            XCTAssertFalse(didCallShowAlert, "Did call viewModel.showAlert")
        }
    }
    
    func testPhotosSuccessImageError() {
        let networkClientMock = NetworkClientMock(resultPhoto: MainScreenViewModelTests.photosSuccessMock, resultImage: MainScreenViewModelTests.imageErrorMock)
        mainScreenViewModel = MainScreenViewModel(networkClient: networkClientMock)
        var didCallShowAlert = false
        mainScreenViewModel.showAlert = { _ in
            didCallShowAlert = true
        }

        var didCallUpdateView = false
        mainScreenViewModel.updateView = {
            didCallUpdateView = true
        }

        let photosExpectation = expectation(description: "photosExpectation")
        photosExpectation.fulfill()
        mainScreenViewModel.loadPhotos()


        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(self.mainScreenViewModel.photos.count, 1)
            XCTAssertEqual(self.mainScreenViewModel.photos.first?.user, "foo")
            XCTAssertTrue(didCallUpdateView, "Did not call viewModel.updateView")
            XCTAssertFalse(didCallShowAlert, "Did call viewModel.showAlert")
        }
    }
    
    func testParsingError() {
        let networkClientMock = NetworkClientMock(resultPhoto: MainScreenViewModelTests.photosErrorMock, resultImage: MainScreenViewModelTests.imageErrorMock)
        mainScreenViewModel = MainScreenViewModel(networkClient: networkClientMock)
        var didCallShowAlert = false
        mainScreenViewModel.showAlert = { _ in
            didCallShowAlert = true
        }

        var didCallUpdateView = false
        mainScreenViewModel.updateView = {
            didCallUpdateView = true
        }

        let photosExpectation = expectation(description: "photosExpectation")
        photosExpectation.fulfill()
        mainScreenViewModel.loadPhotos()


        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(self.mainScreenViewModel.photos.isEmpty)
            XCTAssertFalse(didCallUpdateView, "Did call viewModel.updateView")
            XCTAssertTrue(didCallShowAlert, "Did not call viewModel.showAlert")
        }
    }
    
    func testNetworkError() {
        let networkClientMock = NetworkClientMock(resultPhoto: MainScreenViewModelTests.photosNetworkErrorMock, resultImage: MainScreenViewModelTests.imageNetworkErrorMock)
        mainScreenViewModel = MainScreenViewModel(networkClient: networkClientMock)
        var didCallShowAlert = false
        mainScreenViewModel.showAlert = { _ in
            didCallShowAlert = true
        }

        var didCallUpdateView = false
        mainScreenViewModel.updateView = {
            didCallUpdateView = true
        }

        let photosExpectation = expectation(description: "photosExpectation")
        photosExpectation.fulfill()
        mainScreenViewModel.loadPhotos()


        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(self.mainScreenViewModel.photos.isEmpty)
            XCTAssertFalse(didCallUpdateView, "Did call viewModel.updateView")
            XCTAssertTrue(didCallShowAlert, "Did not call viewModel.showAlert")
        }
    }
}

extension MainScreenViewModelTests {
    static var photosSuccessMock: Result<[Photo], NetworkClient.Error> {
        let photos: [Photo] = [
            Photo(id: 1234, comments: 5, downloads: 5, likes: 5, largeImageURL: "largeImageURL", imageURL: "imageURL", previewURL: nil, webformatURL: nil, tags: "tags", user: "foo")
        ]
        
        return Result.success(photos)
    }
    
    static var imageSuccessMock: Result<UIImage, NetworkClient.Error> {
        let image = UIImage()
        
        return Result.success(image)
    }
    
    static var photosErrorMock: Result<[Photo], NetworkClient.Error> {
        let decodingError = NSError(domain: "com.exercise.AM-Exercise", code: -1, userInfo: nil)
        return Result.failure(.parsing(error: decodingError))
    }
    
    static var imageErrorMock: Result<UIImage, NetworkClient.Error> {
        let decodingError = NSError(domain: "com.exercise.AM-Exercise", code: -2, userInfo: nil)
        return Result.failure(.parsing(error: decodingError))
    }
    
    static var photosNetworkErrorMock: Result<[Photo], NetworkClient.Error> {
        return Result.failure(NetworkClient.Error.general)
    }
    
    static var imageNetworkErrorMock: Result<UIImage, NetworkClient.Error> {
        return Result.failure(NetworkClient.Error.general)
    }
}

