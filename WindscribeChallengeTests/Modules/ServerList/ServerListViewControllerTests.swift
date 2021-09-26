//
//  ServerListViewControllerTests.swift
//  WindscribeChallengeTests
//
//  Created on 26/09/2021.
//

import XCTest
@testable import WindscribeChallenge

class ServerListViewControllerTests: XCTestCase {

    var sut: ServerListViewController!
    
    override func setUp() {
        sut = ServerListViewController.createView(with: serverListViewModel())
        sut.loadViewIfNeeded()
        _ = sut.view
    }
    
    func testServerListViewControllerTitle() {
        XCTAssertEqual(sut.title, "Server List")
    }
}
