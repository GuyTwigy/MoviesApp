//
//  MovieDetailsVC.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import UIKit
import SDWebImage

class MovieDetailsVC: UIViewController {

    var vm: MovieDetailsVM?
    var movie: MovieData?
    var detailsArr: [MovieDetailsVM.SingleDetail] = []
    
    @IBOutlet weak var loader: UIActivityIndicatorView! {
        didSet {
            loader.startAnimating()
        }
    }
    @IBOutlet weak var tblDetails: UITableView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        vm?.delegate = self
        vm?.updateUI()
    }
    
    func setupTableView() {
        tblDetails.dataSource = self
        tblDetails.delegate = self
        tblDetails.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        tblDetails.register(UINib(nibName: "DetailImageCell", bundle: nil), forCellReuseIdentifier: "DetailImageCell")
        tblDetails.register(UINib(nibName: "DetailTrailerShareCell", bundle: nil), forCellReuseIdentifier: "DetailTrailerShareCell")
        tblDetails.rowHeight = UITableView.automaticDimension
        tblDetails.estimatedRowHeight = 200
    }
    
    @IBAction func backTapped(_ sender: Any) {
        backButtonPressed()
    }
}

extension MovieDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        detailsArr.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if detailsArr.count > indexPath.row && !detailsArr.isEmpty {
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
            detailCell.setupCellContent(title: detailsArr[indexPath.row].title, description: detailsArr[indexPath.row].description)
            cell = detailCell
        } else if detailsArr.count == indexPath.row {
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "DetailImageCell", for: indexPath) as! DetailImageCell
            if let imageUrl = Utils.getImageUrl(posterPath: movie?.posterPath ?? "") {
                imageCell.setupCellContent(imageUrl: imageUrl)
            }
            cell = imageCell
        } else if detailsArr.count + 1 == indexPath.row {
            let trailerCell = tableView.dequeueReusableCell(withIdentifier: "DetailTrailerShareCell", for: indexPath) as! DetailTrailerShareCell
            trailerCell.delegate = self
            cell = trailerCell
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension MovieDetailsVC: MovieDetailsVMDelegate {
    func videoFetched(video: VideoData?, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            if let error {
                self.showAlert(title: "Fail to fetched trailer", message: error.localizedDescription)
            } else if let video {
                let vc = TrailerVC()
                vc.videoKey = video.key
                vc.modalPresentationStyle = .pageSheet
                
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                }
                
                self.present(vc, animated: true, completion: nil)
            } else {
                self.showAlert(title: "This movie has no trailer", message: "")
            }
        }
    }
    
    func updateUI(movie: MovieData?, detailsArr: [MovieDetailsVM.SingleDetail], error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            if let error {
                self.showAlert(title: "Data fail to fetched movie", message: error.localizedDescription)
            } else {
                self.detailsArr = detailsArr
                movieTitleLbl.text = movie?.title
                self.movie = movie
                tblDetails.reloadData()
            }
            loader.stopAnimating()
        }
    }
}

extension MovieDetailsVC: DetailTrailerShareCellDelegate {
    func showTrailerTapped() {
        Task {
            await vm?.getTrailer(id: movie?.id ?? (Int(movie?.idString ?? "0")) ?? 0)
        }
    }
    
    func shareTapped() {
        guard let movie else {
            return
        }
        
        let movieDetails = """
                Movie Name: \(movie.title ?? "Not available")
                Language: \(movie.originalLanguage ?? "Not available")
                Release Date: \(movie.releaseDate ?? "Not available")
                Rating: \(movie.voteAverage?.description ?? "-")/10
                """
        
        var itemsToShare: [Any] = [movieDetails]
        
        SDWebImageManager.shared.loadImage(with: Utils.getImageUrl(posterPath: movie.posterPath ?? ""), options: .highPriority, progress: nil) { image, data, error, cacheType, finished, imageURL in
            if let image {
                itemsToShare.append(image)
            }
            
            let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

