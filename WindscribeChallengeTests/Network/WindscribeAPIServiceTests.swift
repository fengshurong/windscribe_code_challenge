//
//  WindscribeAPIServiceTests.swift
//  WindscribeChallengeTests
//
//  Created on 26/09/2021.
//

import XCTest
@testable import WindscribeChallenge

class WindscribeAPIServiceTests: XCTestCase {

    var sut: WindscribeApi!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        sut = WindscribeAPIService.init(urlSession)
        
    }
    
    func testFetchFetchServerListShouldReturnAnServerList() {
        let expectation = self.expectation(description: "should return an server list")
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), self.loadStub(name: "Locations", extension: "json"))
        }
        
        sut.fetchServerList { result in
            switch result {
            case let .success(response):
                let serverList = response.data
                XCTAssertFalse(serverList.isEmpty)
                XCTAssertEqual(serverList.first!.dnsHostname, "us-central.windscribe.com")
                XCTAssertEqual(serverList.first!.name, "US Central")
                expectation.fulfill()
            default: break
            }
        }
        self.waitForExpectations(timeout: 2)
    }
    
    func testFetchServerListShouldReturnAnError() {
        let expectation = self.expectation(description: "should return an error")
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), Data.init())
        }
        
        sut.fetchServerList { result in
            switch result {
            case let .failure(err):
                XCTAssertFalse(err.localizedDescription.isEmpty)
                XCTAssertEqual(err.localizedDescription,
                               "The operation couldn’t be completed. (WindscribeChallenge.ErrorData error 1.)")
                expectation.fulfill()
            default: break
            }
        }
        
        self.waitForExpectations(timeout: 2)
    }
}

extension XCTest {
    func loadStub(name: String, extension: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: `extension`)
        do {
            return try Data(contentsOf: url!)
        } catch {
            fatalError("Data invalid")
        }
    }
}
