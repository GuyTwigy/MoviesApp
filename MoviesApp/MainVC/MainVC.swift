//
//  MainVC.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import UIKit

class MainVC: UIViewController {

    private var vm: MainVM?
<<<<<<< Updated upstream
    private var movies: [MovieData] = []
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
=======
    private var moviesData: MoviesRoot?
    private var movies: [MovieData] = []
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var emptyIndicationLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround(cancelTouches: false)
>>>>>>> Stashed changes
        setupCollectionView()
        setupTextField()
        vm = MainVM()
        vm?.delegate = self
<<<<<<< Updated upstream
        Task {
            await vm?.fetchMovies(query: "insep")
        }
=======
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalWidth(1/2))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/2))
=======
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalWidth(3/4))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(3/4))
>>>>>>> Stashed changes
        
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
    
<<<<<<< Updated upstream
=======
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (moviesData?.results?.count ?? 0) - 5 <= indexPath.row && moviesData?.page ?? 10 < moviesData?.totalPages ?? 100 {
            Task {
                await vm?.fetchMovies(query: searchTextField.text ?? "", page: (moviesData?.page ?? 0) + 1)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailsVC()
        vc.vm = MovieDetailsVM(movie: movies[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
>>>>>>> Stashed changes
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }
}

extension MainVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
<<<<<<< Updated upstream
        
=======
        loader.startAnimating()
        movies.removeAll()
        Task {
            await vm?.fetchMovies(query: textField.text ?? "", page: 1)
        }
>>>>>>> Stashed changes
    }
}

extension MainVC: MainVMDelagate {
<<<<<<< Updated upstream
    func moviesFetched(movies: [MovieData], error: Error?) {
=======
    func moviesFetched(moviesData: MoviesRoot?, addContent: Bool, error: Error?) {
>>>>>>> Stashed changes
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            if let error {
                self.showAlert(title: "Data fail to fetched", message: error.localizedDescription)
<<<<<<< Updated upstream
            } else {
                self.movies.removeAll()
                self.movies = movies
                moviesCollectionView.reloadData()
            }
=======
            } else if addContent {
                let startIndex = self.movies.count
                self.moviesData = moviesData
                self.movies.append(contentsOf: moviesData?.results ?? [])
                
                let endIndex = self.movies.count
                let indexPaths = (startIndex..<endIndex).map {
                    IndexPath(row: $0, section: 0)
                }
                
                self.moviesCollectionView.performBatchUpdates({
                    self.moviesCollectionView.insertItems(at: indexPaths)
                })
            } else {
                self.moviesData = nil
                self.movies.removeAll()
                self.moviesData = moviesData
                self.movies = moviesData?.results ?? []
                moviesCollectionView.reloadData()
            }
            self.emptyIndicationLbl.isHidden = !self.movies.isEmpty
            loader.stopAnimating()
>>>>>>> Stashed changes
        }
    }
}

