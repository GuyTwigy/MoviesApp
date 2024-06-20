//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Guy Twig on 19/06/2024.
//

import UIKit
<<<<<<< Updated upstream

class MovieCell: UICollectionViewCell {

=======
import Kingfisher

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var loader: UIActivityIndicatorView! {
        didSet {
            loader.startAnimating()
        }
    }
>>>>>>> Stashed changes
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
<<<<<<< Updated upstream
    func setupCellContent(movie: MovieData) {
        titleLbl.text = movie.title
        
=======
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLbl.text = ""
        thumbnailImage.image = nil
    }
    
    func setupCellContent(movie: MovieData) {
        loader.startAnimating()
        titleLbl.text = movie.title
        if let imaggeUrl = Utils.getImageUrl(posterPath: movie.posterPath ?? "") {
            thumbnailImage.kf.setImage(with: imaggeUrl, placeholder: UIImage(named: "noImagePlaceholder"))
            loader.stopAnimating()
        }
>>>>>>> Stashed changes
    }
}
