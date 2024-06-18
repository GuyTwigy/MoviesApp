//
//  MainVC.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import UIKit

class MainVC: UIViewController {

    private var vm: MainVM?
    private var movies: [MovieData] = []
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTextField()
        vm = MainVM()
        vm?.delegate = self
        Task {
            await vm?.fetchMovies(query: "insep")
        }
    }
    
    func setupCollectionView() {
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.collectionViewLayout = createLayout()
        moviesCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
    }
    
    func setupTextField() {
        searchTextField.delegate = self
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalWidth(1/2))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/2))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.setupCellContent(movie: movies[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }
}

extension MainVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
    }
}

extension MainVC: MainVMDelagate {
    func moviesFetched(movies: [MovieData], error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            if let error {
                self.showAlert(title: "Data fail to fetched", message: error.localizedDescription)
            } else {
                self.movies.removeAll()
                self.movies = movies
                moviesCollectionView.reloadData()
            }
        }
    }
}

