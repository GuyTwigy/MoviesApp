//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Guy Twig on 19/06/2024.
//

import UIKit

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellContent(movie: MovieData) {
        titleLbl.text = movie.title
        
    }
}
