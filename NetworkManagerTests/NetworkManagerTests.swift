//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Emir Alkal on 19.05.2023.
//

import XCTest
@testable import NetworkManager

final class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager?
    
    override func setUpWithError() throws {
        networkManager = NetworkManager.shared
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }

    func testExample() throws {
    }
}
