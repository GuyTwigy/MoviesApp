//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import UIKit

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var loader: UIActivityIndicatorView! {
        didSet {
            loader.startAnimating()
        }
    }

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLbl.text = ""
        thumbnailImage.image = nil
    }
    
    func setupCellContent(movie: MovieData) {
        loader.startAnimating()
        titleLbl.text = movie.title
        if let imaggeUrl = Utils.getImageUrl(posterPath: movie.posterPath ?? "") {
//            thumbnailImage.kf.setImage(with: imaggeUrl, placeholder: UIImage(named: "noImagePlaceholder"))
            loader.stopAnimating()
        }
    }
}

