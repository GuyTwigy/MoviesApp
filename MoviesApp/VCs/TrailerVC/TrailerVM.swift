//
//  TrailerVM.swift
//  MoviesApp
//
//  Created by Guy Twig on 23/06/2024.
//

import Foundation

protocol TrailerVMDelegate: AnyObject {
    func showVideo(request: URLRequest?)
}

class TrailerVM {
    
    weak var delegate: TrailerVMDelegate?
    var videoKey: String
    
    init(videoKey: String) {
        self.videoKey = videoKey
    }
    
    func loadVideo() {
        let urlString = "https://www.youtube.com/embed/\(videoKey)"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            delegate?.showVideo(request: request)
        } else {
            delegate?.showVideo(request: nil)
        }
    }
}
