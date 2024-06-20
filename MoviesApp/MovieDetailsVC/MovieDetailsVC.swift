//
//  MovieDetailsVC.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import UIKit

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
            
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension MovieDetailsVC: MovieDetailsVMDelegate {
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
