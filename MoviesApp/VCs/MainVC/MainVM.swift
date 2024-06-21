//
//  MainVM.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import Foundation

protocol MainVMDelagate: AnyObject {
    func moviesFetched(moviesData: MoviesRoot?, addContent: Bool, error: Error?)
}

class MainVM {
    weak var delegate: MainVMDelagate?
    private var networkManager = NetworkManager()
    
    func fetchMovies(optionSelection: OptionsSelection, query: String, page: Int) async {
        do {
            let moviesData = try await networkManager.fetchMovies(optionSelected: optionSelection, query: query, page: page)
            delegate?.moviesFetched(moviesData: moviesData, addContent: page > 1, error: nil)
        } catch {
            print("Error: \(error.localizedDescription)")
            delegate?.moviesFetched(moviesData: nil, addContent: false, error: error)
        }
    }
}
