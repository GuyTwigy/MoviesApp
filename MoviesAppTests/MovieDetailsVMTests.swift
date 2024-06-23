//
//  MovieDetailsVMTests.swift
//  MoviesAppTests
//
//  Created by Guy Twig on 23/06/2024.
//

import XCTest
@testable import MoviesApp

final class MovieDetailsVMTests: XCTestCase {
    
    var vm: MovieDetailsVM?
    var dataService: GetTrailerProtocol?
    var mockMovies: MovieData?
    var detailsArr: [MovieDetailsVM.SingleDetail] = []
    
    
    override func setUpWithError() throws {
        dataService = NetworkManager()
        mockMovies = MovieData(id: 1, idString: "1", title: "Mock Movie", posterPath: "/mock", overview: "Overview", releaseDate: "2023-01-01", originalLanguage: "en", voteAverage: 8.0, date: Date())
        if let dataService, let mockMovies {
            vm = MovieDetailsVM(dataService: dataService, movie: mockMovies)
        }
    }
    
    override func tearDownWithError() throws {
        detailsArr = []
        vm = nil
        dataService = nil
        mockMovies = nil
    }
    
    func test_MovieDetailsVM_init_movieNil() {
        // Given
        mockMovies = nil
        
        // When
        detailsArr = [MovieDetailsVM.SingleDetail(title: "Overiew:", description: mockMovies?.overview ?? "Not Available"),
                      MovieDetailsVM.SingleDetail(title: "Rating:", description: "\(mockMovies?.voteAverage?.description ?? "-")/10"),
                      MovieDetailsVM.SingleDetail(title: "Language:", description: mockMovies?.originalLanguage ?? "Not Available"),
                      MovieDetailsVM.SingleDetail(title: "Release Date:", description: mockMovies?.releaseDate ?? "Not Available")]
        
        //then
        XCTAssertNil(mockMovies)
        XCTAssertEqual(detailsArr[0].description, "Not Available")
        XCTAssertEqual(detailsArr[0].title, "Overiew:")
        XCTAssertEqual(detailsArr[1].title, "Rating:")
        XCTAssertEqual(detailsArr[2].title, "Language:")
        XCTAssertEqual(detailsArr[3].title, "Release Date:")
    }
    
    func test_MovieDetailsVM_init_movieNotNil() {
        // When
        detailsArr = [MovieDetailsVM.SingleDetail(title: "Overiew:", description: mockMovies?.overview ?? "Not Available"),
                      MovieDetailsVM.SingleDetail(title: "Rating:", description: "\(mockMovies?.voteAverage?.description ?? "-")/10"),
                      MovieDetailsVM.SingleDetail(title: "Language:", description: mockMovies?.originalLanguage ?? "Not Available"),
                      MovieDetailsVM.SingleDetail(title: "Release Date:", description: mockMovies?.releaseDate ?? "Not Available")]
        
        //then
        XCTAssertNotNil(mockMovies)
        XCTAssertEqual(detailsArr[0].description, "Overview")
        XCTAssertEqual(detailsArr[0].title, "Overiew:")
        XCTAssertEqual(detailsArr[1].title, "Rating:")
        XCTAssertEqual(detailsArr[2].title, "Language:")
        XCTAssertEqual(detailsArr[3].title, "Release Date:")
        
    }
    
    func test_MovieDetailsVM_getTrailer() async {
        //given
        
        
        // When
        let expectation = self.expectation(description: "Get Trailer")
        do {
            let videoData = try await dataService?.getTrailer(id: "1817")
            expectation.fulfill()
            XCTAssertNotNil(videoData)
            XCTAssertNotNil(videoData?.first?.key)
            XCTAssertNotNil(videoData?.first?.type)
        } catch {
            XCTFail()
        }
        
        //then
        await fulfillment(of: [expectation], timeout: 10.0,  enforceOrder: true)
    }
}
