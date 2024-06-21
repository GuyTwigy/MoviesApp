//
//  MainVC.swift
//  MoviesApp
//
//  Created by Guy Twig on 18/06/2024.
//

import UIKit

class MainVC: UIViewController {

    private var vm: MainVM?
    private var moviesData: MoviesRoot?
    private var movies: [MovieData] = []
    private var optionsArr: [String] = ["Top", "Popular", "Trending", "Now Playing", "Upcoming"]
    private var suggestedMovies: [MovieData] = []
    private var optionSelected: OptionsSelection = .top
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var emptyIndicationLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround(cancelTouches: false)
        setupCollectionViews()
        setupTextField()
        vm = MainVM()
        vm?.delegate = self
        loader.startAnimating()
        Task {
            await vm?.fetchMovies(optionSelection: .top, query: "", page: 1)
        }
    }
    
    func setupCollectionViews() {
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.collectionViewLayout = createLayout()
        moviesCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        
        optionsCollectionView.delegate = self
        optionsCollectionView.dataSource = self
        optionsCollectionView.register(UINib(nibName: "OptionsCell", bundle: nil), forCellWithReuseIdentifier: "OptionsCell")
        
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.dataSource = self
        suggestionsCollectionView.register(UINib(nibName: "SuggestionsCell", bundle: nil), forCellWithReuseIdentifier: "SuggestionsCell")
    }
    
    func setupTextField() {
        searchTextField.delegate = self
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalWidth(3/4))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(3/4))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func optionTapped() {
        loader.startAnimating()
        searchTextField.text = ""
        movies.removeAll()
        flipAndHideContentView()
        Task {
            await vm?.fetchMovies(optionSelection: optionSelected, query: "", page: 1)
        }
    }
    
    func flipAndHideContentView() {
        UIView.transition(with: moviesCollectionView, duration: 0.5, options: .transitionFlipFromLeft, animations: { [weak self] in
            guard let self else {
                return
            }
            
            self.moviesCollectionView.reloadData()
        })
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moviesCollectionView {
            return movies.count
        } else if collectionView == optionsCollectionView {
            return optionsArr.count
        } else {
            return suggestedMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == moviesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.setupCellContent(movie: movies[indexPath.row])
            return cell
        } else if collectionView == optionsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCell", for: indexPath) as! OptionsCell
            cell.setupCellContent(title: optionsArr[indexPath.row], isSelected: optionsArr[indexPath.row] == optionSelected.rawValue )
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionsCell", for: indexPath) as! SuggestionsCell
            cell.setupCellContent(movie: suggestedMovies[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == moviesCollectionView {
            if (moviesData?.results?.count ?? 0) - 5 <= indexPath.row && moviesData?.page ?? 10 < moviesData?.totalPages ?? 100 {
                Task {
                    await vm?.fetchMovies(optionSelection: optionSelected, query: searchTextField.text ?? "", page: (moviesData?.page ?? 0) + 1)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == optionsCollectionView {
            let width = (view.frame.width) / 3.5
            let height = (collectionView.frame.height) * 0.9
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == moviesCollectionView {
            let vc = MovieDetailsVC()
            vc.vm = MovieDetailsVM(movie: movies[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        } else if collectionView == optionsCollectionView {
            optionSelected = OptionsSelection(intValue: indexPath.row)
            optionsCollectionView.reloadData()
            optionTapped()
        } else {
            let vc = MovieDetailsVC()
            vc.vm = MovieDetailsVM(movie: suggestedMovies[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }
}

extension MainVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        loader.startAnimating()
        movies.removeAll()
        optionSelected = .search
        Task {
            await vm?.fetchMovies(optionSelection: .search, query: textField.text ?? "", page: 1)
        }
    }
}

extension MainVC: MainVMDelagate {
    func moviesFetched(moviesData: MoviesRoot?, addContent: Bool, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            if let error {
                self.showAlert(title: "Data fail to fetched", message: error.localizedDescription)
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
        }
    }
}
