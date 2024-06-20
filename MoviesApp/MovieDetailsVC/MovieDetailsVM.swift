//
//  MovieDetailsVM.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import Foundation

protocol MovieDetailsVMDelegate: AnyObject {
    func updateUI(movie: MovieData?, detailsArr: [MovieDetailsVM.SingleDetail], error: Error?)
}

class MovieDetailsVM {
    
    struct SingleDetail {
        let title: String
        let description: String
    }
    
    var movie: MovieData?
    var detailsArr: [SingleDetail] = []
    weak var delegate: MovieDetailsVMDelegate?
    
    init(movie: MovieData) {
        self.movie = movie
    }
    
    func updateUI() {
        if let movie {
            detailsArr.removeAll()
            detailsArr = [SingleDetail(title: "Overiew:", description: movie.overview ?? "Not Available"),
                          SingleDetail(title: "Release Date:", description: movie.releaseDate ?? "Not Available"),
                          SingleDetail(title: "Language:", description: movie.originalLanguage ?? "Not Available"),
                          SingleDetail(title: "Rating:", description: "\(movie.voteAverage ?? 0.0)/10")]
            delegate?.updateUI(movie: movie, detailsArr: detailsArr, error: nil)
        } else {
            delegate?.updateUI(movie: movie, detailsArr: detailsArr, error: URLError.cannotDecodeContentData as? Error)
        }
    }
}
