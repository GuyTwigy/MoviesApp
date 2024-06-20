//
//  MovieDetailsVM.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import Foundation

protocol MovieDetailsVMDelegate: AnyObject {
    func updateUI(movie: MovieData?, detailsArr: [MovieDetailsVM.SingleDetail], error: Error?)
    func videoFetched(video: VideoData?, error: Error?)
}

class MovieDetailsVM {
    
    struct SingleDetail {
        let title: String
        let description: String
    }
    
    private var movie: MovieData?
    private var detailsArr: [SingleDetail] = []
    weak var delegate: MovieDetailsVMDelegate?
    private var networkManager = NetworkManager()
    
    init(movie: MovieData) {
        self.movie = movie
    }
    
    func updateUI() {
        if let movie {
            detailsArr.removeAll()
            detailsArr = [SingleDetail(title: "Overiew:", description: movie.overview ?? "Not Available"),
                          SingleDetail(title: "Rating:", description: "\(movie.voteAverage?.description ?? "-")/10"),
                          SingleDetail(title: "Language:", description: movie.originalLanguage ?? "Not Available"),
                          SingleDetail(title: "Release Date:", description: movie.releaseDate ?? "Not Available")]
            delegate?.updateUI(movie: movie, detailsArr: detailsArr, error: nil)
        } else {
            delegate?.updateUI(movie: movie, detailsArr: detailsArr, error: URLError.cannotDecodeContentData as? Error)
        }
    }
    
    func getTrailer(id: Int) async {
        do {
            let videoData = try await networkManager.getTrailer(id: String(id))
            delegate?.videoFetched(video: videoData.first, error: nil)
        } catch {
            print("Error: \(error.localizedDescription)")
            delegate?.videoFetched(video: nil, error: error)
        }
    }
}
