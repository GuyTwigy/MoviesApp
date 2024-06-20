//
//  DetailImageCell.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import UIKit
import SDWebImage

class DetailImageCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieImageHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellContent(imageUrl: URL) {
        movieImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "noImagePlaceholder")) { [weak self] image, error, cacheType, imageURL in
            guard let self, let image else {
                return
            }
            
            if let _ = error {
                movieImage.image = UIImage(named: "noImagePlaceholder")
                return
            }
            
            let aspectRatio = image.size.height / image.size.width
            let imageViewWidth = self.contentView.frame.width
            let imageViewHeight = imageViewWidth * aspectRatio
            self.movieImageHeightConstraint.constant = imageViewHeight
            self.layoutIfNeeded()
        }
    }
}
