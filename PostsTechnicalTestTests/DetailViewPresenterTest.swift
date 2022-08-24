//
//  DetailViewPresenterTest.swift
//  PostsTechnicalTestTests
//
//  Created by Juan Harrington on 18/08/22.
//

import XCTest
@testable import PostsTechnicalTest


class DetailViewPresenterTests: XCTestCase {
    var sut: DetailViewPresenter!
    
    var fetchData: FetchDataMock!
    var storage: StorageMock!
    var view: DetailMockView!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        fetchData = FetchDataMock()
        view = DetailMockView()
        storage = StorageMock()
        
        //sut instantiation
        sut = DetailViewPresenter(fetchData: fetchData, fetchCoreData: storage)
        sut.view = view
    }
    
    
    func testWhenUserAndCommentsComesFromServer() throws {
        //Given
        let givenServerUser =  UserPostsModel(name: "", email: "", phone: "", website: "", id: "1")
        let givenComment = CommetModel(postId: "", id: "", body: "")
        let givenComments = [givenComment]
        
        //When
        sut.handleViewDidLoad(postId: givenComment.postId, userId: givenServerUser.id)
        fetchData.recivedUsersCompetion!(.success(givenServerUser))
        fetchData.recivedCommentsCompetion!(.success(givenComments))
        
        //Then
        XCTAssertEqual(view.recivedUser?.id, "1")
    }
    
    func testWhenUserAndCommentsComesFromStorage() throws {
        //given
        let givenServerUser =  UserPostsModel(name: "Storage", email: "", phone: "", website: "", id: "4")
        let givenComment = CommetModel(postId: "", id: "", body: "")
        let givenComments = [givenComment]
        storage.commentModel = givenComments
        storage.userModel = givenServerUser

        //when
        sut.handleViewDidLoad(postId: givenComment.postId, userId: givenServerUser.id)
        fetchData.recivedUsersCompetion!(.failure(.networkError(errormessage: "error")))
        
        //then
        XCTAssertEqual(view.recivedComments?.count, 1)
        //XCTAssertEqual(view.recivedUser?.id, "4")
        XCTAssertEqual(view.recivedUser?.name, "Storage")

    }
    
    func testWhenFailureReciveAlert() throws {
        sut.handleViewDidLoad(postId: "String", userId: "String")
        fetchData.recivedUsersCompetion!(.failure(.networkError(errormessage: "")))

        XCTAssertEqual(view.recivedAlert, "Error: Data not founded")
    }
}
