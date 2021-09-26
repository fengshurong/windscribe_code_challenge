//
//  ServerListTests.swift
//  WindscribeChallengeTests
//
//  Created on 26/09/2021.
//

import XCTest
@testable import WindscribeChallenge

public func serverListViewModel() -> ServerListViewModel {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    let urlSession = URLSession(configuration: configuration)
    let service = WindscribeAPIService(urlSession)
    return ServerListViewModel(service: service)
}

class ServerListViewModelTests: XCTestCase {
    
    var sut: ServerListViewModel!
    
    override func setUp() {
        sut = serverListViewModel()
    }
    
    func testRetrevingLocationsSuccess() {
        let expectation = self.expectation(description: "should excute success block")
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse.init(), self.loadStub(name: "Locations", extension: "json"))
        }
        
        sut.retriveServerList(success: {
            XCTAssertFalse(self.sut.locations.isEmpty)
            expectation.fulfill()
        }, error: { _ in
            XCTFail("should not fail")
        })
        self.waitForExpectations(timeout: 2)
    }
    
    func testRetrevingLocationsFail() {
        let expectation = self.expectation(description: "should excute error block")
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse.init(), Data())
        }
        
        sut.retriveServerList(success: {
            XCTFail("should not succeed")
        }, error: { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 2)
    }
}
