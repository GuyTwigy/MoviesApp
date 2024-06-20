//
//  VideoData.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import Foundation

struct VideoData: Decodable {
    let key: String
    let type: String
}

struct VideosResponse: Decodable {
    let results: [VideoData]
}
