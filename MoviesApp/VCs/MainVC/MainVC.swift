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
    private var isLocalFetch: Bool = false
    
    @IBOutlet weak var loader: UIActivityIndicatorView! {
        didSet {
            loader.startAnimating()
        }
    }
    @IBOutlet weak var suggestionLoader: UIActivityIndicatorView! {
        didSet {
            suggestionLoader.startAnimating()
        }
    }
    @IBOutlet weak var titleOptionsLbl: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tblMovies: UITableView!
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var emptyIndicationLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        hideKeyboardWhenTappedAround(cancelTouches: false)
        setupCollectionViewsAndTableView()
        setupTextField()
        vm = MainVM()
        vm?.delegate = self
        Task {
            await vm?.fetchMovies(optionSelection: .top, query: "", page: 1)
            await vm?.fetchSuggestion()
        }
    }
    
    func setupCollectionViewsAndTableView() {
        tblMovies.delegate = self
        tblMovies.dataSource = self
        tblMovies.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        
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
        UIView.transition(with: tblMovies, duration: 0.5, options: .transitionFlipFromLeft, animations: { [weak self] in
            guard let self else {
                return
            }
            
            switch optionSelected {
            case .top:
                titleOptionsLbl.text = "Top Rated Movies"
            case .popular:
                titleOptionsLbl.text = "Popular Movies"
            case .trending:
                titleOptionsLbl.text = "Trending Movies"
            case .nowPlaying:
                titleOptionsLbl.text = "Now Playing Movies"
            case .upcoming:
                titleOptionsLbl.text = "Upcoming Movies"
            case .search:
                titleOptionsLbl.text = "Search results for: \(searchTextField.text ?? "")"
            }
            self.tblMovies.reloadData()
        })
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.setupCellContent(movie: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailsVC()
        vc.vm = MovieDetailsVM(movie: movies[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (moviesData?.results?.count ?? 0) - 5 <= indexPath.row && moviesData?.page ?? 10 < moviesData?.totalPages ?? 100, !isLocalFetch {
            Task {
                await vm?.fetchMovies(optionSelection: optionSelected, query: searchTextField.text ?? "", page: (moviesData?.page ?? 0) + 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == optionsCollectionView {
            return optionsArr.count
        } else {
            return suggestedMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == optionsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCell", for: indexPath) as! OptionsCell
            cell.setupCellContent(title: optionsArr[indexPath.row], isSelected: optionsArr[indexPath.row] == optionSelected.rawValue )
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionsCell", for: indexPath) as! SuggestionsCell
            cell.setupCellContent(movie: suggestedMovies[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == optionsCollectionView {
            let width = (UIScreen.main.bounds.width) / 3.5
            let height = (collectionView.frame.height) * 0.9
            return CGSize(width: width, height: height)
        } else if collectionView == suggestionsCollectionView {
            let width = (UIScreen.main.bounds.width) / 1.5
            let height = collectionView.frame.height
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if collectionView == optionsCollectionView {
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
        if optionSelected != .search {
            optionsCollectionView.reloadData()
            optionSelected = .search
        }
        titleOptionsLbl.text = "Search results for: '\(searchTextField.text ?? "")'"
        Task {
            await vm?.fetchMovies(optionSelection: .search, query: textField.text ?? "", page: 1)
        }
    }
}

extension MainVC: MainVMDelagate {
    func suggestionFetched(movies: [MovieData], error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            if let error {
                self.showAlert(title: "Data fail to fetched", message: error.localizedDescription)
            } else {
                self.suggestedMovies.removeAll()
                self.suggestedMovies = movies
                self.suggestionsCollectionView.reloadData()
            }
            self.suggestionLoader.stopAnimating()
        }
    }
    
    func moviesFetched(moviesData: MoviesRoot?, addContent: Bool, localFetch: Bool, error: Error?) {
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
                
                self.tblMovies.performBatchUpdates({
                    self.tblMovies.insertRows(at: indexPaths, with: .automatic)
                })
            } else {
                self.moviesData = nil
                self.movies.removeAll()
                self.moviesData = moviesData
                self.movies = moviesData?.results ?? []
                tblMovies.reloadData()
            }
            self.isLocalFetch = localFetch
            self.emptyIndicationLbl.isHidden = !self.movies.isEmpty
            loader.stopAnimating()
        }
    }
}
