//
//  NetworkClientTests.swift
//  AM-ExerciseTests
//
//  Created by Aleksandr Dainiak on 03.04.2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import XCTest
@testable import AM_Exercise

class NetworkClientTests: XCTestCase {
    
    private var photosJsonData: Data!
    private var networkClient: NetworkClientProtocol!
    private var mockURLSession: MockURLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        photosJsonData = loadDataInJSONFile(fileName: "photosStub")!
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    override func tearDown() {
        networkClient = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testSuccessfullPhotosResponse() {
        let mockURLSession = MockURLSession(data: photosJsonData, urlResponse: nil, responseError: nil)
        networkClient = NetworkClient(urlSession: mockURLSession)
        let photosExpectation = expectation(description: "photosExpectation")
        var photos: [Photo]?
        
        networkClient.fetchImages(for: "", page: 1) { result in
            switch result {
            case .success(let items):
                photos = items
                photosExpectation.fulfill()
                
            case .failure(_):
                photosExpectation.fulfill()
            }
        }
        
        let expectedName = "Mint_Foto"
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(photos?.count, 20)
            XCTAssertEqual(photos?.first?.user, expectedName)
        }
    }
    
    func testEmptyDataPhotosResponse() {
        networkClient = nil
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        networkClient = NetworkClient(urlSession: mockURLSession)
        let photosExpectation = expectation(description: "photosExpectation")
        var photos: [Photo]?
        var expectedError: NetworkClient.Error?
        
        networkClient.fetchImages(for: "", page: 1) { result in
            switch result {
            case .success(let items):
                photos = items
                photosExpectation.fulfill()
                
            case .failure(let error):
                expectedError = error
                photosExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNil(photos)
            if case .invalid = expectedError {
                XCTAssertTrue(true, ".invalid error type equals to expected")
            } else {
                XCTAssertTrue(false, "invalid error type does not equal to expected")
            }
        }
    }
    
    func testInvalidJsonResponse() {
        networkClient = nil
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        networkClient = NetworkClient(urlSession: mockURLSession)
        let photosExpectation = expectation(description: "photosExpectation")
        var photos: [Photo]?
        var expectedError: NetworkClient.Error?
        
        networkClient.fetchImages(for: "", page: 1) { result in
            switch result {
            case .success(let items):
                photos = items
                photosExpectation.fulfill()
                
            case .failure(let error):
                expectedError = error
                photosExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNil(photos)
            if case .invalid = expectedError {
                XCTAssertTrue(true, ".invalid error type equals to expected")
            } else {
                XCTAssertTrue(false, ".invalid error type does not equal to expected")
            }
        }
    }
    
    func testTransportErrorFromResponse() {
        networkClient = nil
        let nsError = NSError(domain: "Foo error", code: 401, userInfo: [:])
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nsError)
        networkClient = NetworkClient(urlSession: mockURLSession)
        let photosExpectation = expectation(description: "photosExpectation")
        var photos: [Photo]?
        var expectedError: NetworkClient.Error?
        
        networkClient.fetchImages(for: "", page: 1) { result in
            switch result {
            case .success(let items):
                photos = items
                photosExpectation.fulfill()
                
            case .failure(let error):
                expectedError = error
                photosExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNil(photos)
            if case .network = expectedError {
                XCTAssertTrue(true, ".network error type equals to expected")
            } else {
                XCTAssertTrue(false, "network error type does not equal to expected")
            }
        }
    }
    
    func testServiceErrorFromResponse() {
        networkClient = nil
        let expectedStatusCode = 404
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: expectedStatusCode, httpVersion: nil, headerFields: [:])
        mockURLSession = MockURLSession(data: nil, urlResponse: response, responseError: nil)
        networkClient = NetworkClient(urlSession: mockURLSession)
        let photosExpectation = expectation(description: "photosExpectation")
        var photos: [Photo]?
        var expectedError: NetworkClient.Error?
        
        networkClient.fetchImages(for: "", page: 1) { result in
            switch result {
            case .success(let items):
                photos = items
                photosExpectation.fulfill()
                
            case .failure(let error):
                expectedError = error
                photosExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNil(photos)
            
            var statusCode = 0
            
            if case .invalid(response: let response) = expectedError {
                statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            }
            XCTAssertEqual(statusCode, expectedStatusCode)
        }
    }
}

extension NetworkClientTests {
    func loadDataInJSONFile(fileName: String) -> Data? {
        let bundle = Bundle(for: NetworkClient.self)
        guard let filePath = bundle.path(forResource: fileName, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
                  return nil
              }
        return data
    }
}
