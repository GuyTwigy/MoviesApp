//
//  TrailerVMTests.swift
//  MoviesAppTests
//
//  Created by Guy Twig on 23/06/2024.
//

import XCTest
@testable import MoviesApp

final class TrailerVMTests: XCTestCase {
    
    var vm: MovieDetailsVM?
    var dataService: GetTrailerProtocol?
    var mockMovies: MovieData?
    
    override func setUpWithError() throws {
        dataService = NetworkManager()
        mockMovies = MovieData(id: 1, idString: "1", title: "Mock Movie", posterPath: "/mock", overview: "Overview", releaseDate: "2023-01-01", originalLanguage: "en", voteAverage: 8.0, date: Date())
        if let dataService, let mockMovies {
            vm = MovieDetailsVM(dataService: dataService, movie: mockMovies)
        }
    }
    
    override func tearDownWithError() throws {
        vm = nil
        dataService = nil
        mockMovies = nil
    }
    
    func test_TrailerVMTests_loadVideo() async {
        //given
        let expectation = self.expectation(description: "Get Trailer")
        do {
            let videoData = try await dataService?.getTrailer(id: "1817")
            expectation.fulfill()
            XCTAssertNotNil(videoData)
            XCTAssertNotNil(videoData?.first?.key)
            XCTAssertNotNil(videoData?.first?.type)
            
            //when
            let urlString = "https://www.youtube.com/embed/\(videoData?.first?.key ?? "")"
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                //then
                XCTAssertNotNil(request)
            }
        } catch {
            XCTFail()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0,  enforceOrder: true)
    }
}
