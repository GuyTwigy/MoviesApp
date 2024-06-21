//
//  SuggestionsCell.swift
//  MoviesApp
//
//  Created by Guy Twig on 21/06/2024.
//

import UIKit

class SuggestionsCell: UICollectionViewCell {

    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieTitle.text = ""
        ratingLbl.text = ""
        movieImage.image = nil
        imageLoader.isHidden = true
    }
    
    func setupCellContent(movie: MovieData) {
        imageLoader.startAnimating()
        movieTitle.text = movie.title
        ratingLbl.text = "\(movie.voteAverage?.description ?? "-")/10"
        
        if let imageURL = Utils.getImageUrl(posterPath: movie.posterPath ?? "") {
            movieImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "noImagePlaceholder")) { [weak self] _,_,_,_ in
                guard let self else {
                    return
                }
                
                self.imageLoader.stopAnimating()
            }
        }
    }
}
