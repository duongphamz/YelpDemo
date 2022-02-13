//
//  BusinessDetail.swift
//  HomeTestTests
//
//  Created by Duong Pham on 13/02/2022.
//

import XCTest
@testable import HomeTest
class BusinessDetailTests: XCTestCase {
    var viewModel: BusinessDetailViewModel!
    
    override func setUp() {
        super.setUp()
        self.viewModel = BusinessDetailViewModel(id: "1")
        
    }

    func testConvertDataToViewModelFunction() throws {
        let businessDetail = Business(id: "1", imageUrl: "", name: "starbuck", location: nil, categories: nil, hours: nil, rating: nil, phone: nil)
        let viewModels = viewModel.convertDataToViewModel(business: businessDetail)
        XCTAssertTrue(viewModels.first?.description == "starbuck")
        XCTAssertTrue(viewModels.count == 5)
    }
}
