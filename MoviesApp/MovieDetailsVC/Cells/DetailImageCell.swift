//
//  DetailImageCell.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import UIKit

class DetailImageCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellContent(imageUrl: URL) {
        movieImage.kf.setImage(with: imageUrl,placeholder: UIImage(named: "noImagePlaceholder"))
    }
}
