//
//  URLShortenerServiceTests.swift
//  LinkShortenerTests
//
//  Created by Jade Silveira on 09/12/21.
//

@testable import LinkShortener
import XCTest
import NetworkCore

extension URLShortenerResponse {
    static func fixture(
        alias: String = "31959",
        originalURL: String = "www.google.com",
        shortURL: String = "https://url-shortener-nu.herokuapp.com/short/31959"
    ) -> URLShortenerResponse {
        URLShortenerResponse(
            alias: alias,
            originalURL: originalURL,
            shortURL: shortURL)
    }
}

final class URLShortenerServiceTests: XCTestCase {
    private let sessionMock = SessionMock()
    private let queueSpy = DispatchQueueSpy()
    private let defaultsSpy = UserDefaultsSpy()
    
    private lazy var networkDummy = Network(session: sessionMock, queue: queueSpy)
    private lazy var storageDummy = Storage(defaults: defaultsSpy)
    
    private lazy var sut = URLShortenerService(network: networkDummy, storage: storageDummy)
    
    func testPostAlias_WhenNilErrorAndResponseIsHTTPURLResponseAndStatusCodeIsSuccessAndDataIsNotNilAndDataWasParsedToObject_ShouldCompletionWithSuccess() throws {
        let links: [String: Any] = ["self": "www.google.com", "short": "https://url-shortener-nu.herokuapp.com/short/31959"]
        let jsonObject: [String: Any] = ["alias": "31959", "_links": links]
        let data = try JSONSerialization.data(withJSONObject: jsonObject)
        
        let url = URL(string: "www.google.com")!
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        sessionMock.makeRequestUrlRequestCompletionExpectedResult = (data: data, response: urlResponse, error: nil)
        let expectation = XCTestExpectation(description: "postAlias completion")
        
        sut.postAlias(text: "www.google.com") { result in
            expectation.fulfill()
            XCTAssertEqual(result, .success(.fixture()))
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(queueSpy.callAsyncCallsCount, 1)
    }
    
    func testPostAlias_WhenNilErrorAndResponseIsHTTPURLResponseAndStatusCodeIsSuccessAndDataIsNotNilAndDataWasNotParsedToObject_ShouldCompletionWithFailureJsonParse() throws {
        let links: [String: Any] = ["original": "www.google.com", "shortURL": "https://url-shortener-nu.herokuapp.com/short/31959"]
        let jsonObject: [String: Any] = ["alias": "31959", "_links": links]
        let data = try JSONSerialization.data(withJSONObject: jsonObject)
        
        let url = URL(string: "www.google.com")!
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        sessionMock.makeRequestUrlRequestCompletionExpectedResult = (data: data, response: urlResponse, error: nil)
        let expectation = XCTestExpectation(description: "postAlias completion")
        
        sut.postAlias(text: "www.google.com") { result in
            expectation.fulfill()
            XCTAssertEqual(result, .failure(.jsonParse))
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(queueSpy.callAsyncCallsCount, 1)
    }
    
    func testPostAlias_WhenNilErrorAndResponseIsHTTPURLResponseAndStatusCodeIsSuccessAndDataIsNotNilAndDataWasNotParsedToObject_ShouldCompletionWithFailureNilData() throws {
        let url = URL(string: "www.google.com")!
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        sessionMock.makeRequestUrlRequestCompletionExpectedResult = (data: nil, response: urlResponse, error: nil)
        let expectation = XCTestExpectation(description: "postAlias completion")
        
        sut.postAlias(text: "www.google.com") { result in
            expectation.fulfill()
            XCTAssertEqual(result, .failure(.nilData))
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(queueSpy.callAsyncCallsCount, 1)
    }
    
    func testPostAlias_WhenNilErrorAndResponseIsHTTPURLResponseAndStatusCodeIsSuccessAndDataIsNotNilAndDataWasNotParsedToObject_ShouldCompletionWithFailureStatusCode() throws {
        let url = URL(string: "www.google.com")!
        let urlResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        sessionMock.makeRequestUrlRequestCompletionExpectedResult = (data: nil, response: urlResponse, error: nil)
        let expectation = XCTestExpectation(description: "postAlias completion")
        
        sut.postAlias(text: "www.google.com") { result in
            expectation.fulfill()
            XCTAssertEqual(result, .failure(.statusCode(code: .clientError)))
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(queueSpy.callAsyncCallsCount, 1)
    }
    
    func testPostAlias_WhenNilErrorAndResponseIsHTTPURLResponseAndStatusCodeIsSuccessAndDataIsNotNilAndDataWasNotParsedToObject_ShouldCompletionWithFailureNilResponse() throws {
        sessionMock.makeRequestUrlRequestCompletionExpectedResult = (data: nil, response: nil, error: nil)
        let expectation = XCTestExpectation(description: "postAlias completion")
        
        sut.postAlias(text: "www.google.com") { result in
            expectation.fulfill()
            XCTAssertEqual(result, .failure(.nilResponse))
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(queueSpy.callAsyncCallsCount, 1)
    }
    
    func testPostAlias_WhenNilErrorAndResponseIsHTTPURLResponseAndStatusCodeIsSuccessAndDataIsNotNilAndDataWasNotParsedToObject_ShouldCompletionWithFailureServerError() throws {
        sessionMock.makeRequestUrlRequestCompletionExpectedResult = (data: nil, response: nil, error: ApiError.generic)
        let expectation = XCTestExpectation(description: "postAlias completion")
        
        sut.postAlias(text: "www.google.com") { result in
            expectation.fulfill()
            XCTAssertEqual(result, .failure(.server(error: ApiError.generic)))
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(queueSpy.callAsyncCallsCount, 1)
    }
}
