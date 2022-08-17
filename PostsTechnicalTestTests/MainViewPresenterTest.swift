//
//  PostsTechnicalTest.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 9/08/22.
//

import XCTest
@testable import PostsTechnicalTest

class MainViewPresenterTests: XCTestCase {
    
    var sut: MainViewPresenter!
    
    var fetchData: FetchDataMock!
    var storage: StorageMock!
    var view: MockView!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        fetchData = FetchDataMock()
        view = MockView()
        storage = StorageMock()
        
        //sut instantiation
        sut = MainViewPresenter(fetchData: fetchData, fetchCoreData: storage)
        sut.view = view
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //Given
        let givenServerModel = PostModel(userId: "a", id: "", title: "", body: "")
        let serverModelArray: [PostModel] = [givenServerModel]
        //fetchData = serverModelArray
        //When
        sut.handleViewDidLoad()
        fetchData.recivedPostsCompetion!(.success(serverModelArray))
        //Then
        XCTAssertEqual(view.recivedArray?.count, 1)
    }
    
    func testWhenFailureReciveAlert() throws {
        //When
        sut.handleViewDidLoad()
        fetchData.recivedPostsCompetion!(.failure(.networkError(errormessage: "couldn\'t find data, sending coredata favorites")))

        XCTAssertEqual(view.recivedAlert, "couldn\'t find data, sending coredata favorites")

    }
}
