//
//  OptionsCell.swift
//  MoviesApp
//
//  Created by Guy Twig on 21/06/2024.
//

import UIKit

class OptionsCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var optionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        optionView.backgroundColor = .white
    }
    
    func setupCellContent(title: String, isSelected: Bool) {
        titleLbl.text = title
        optionView.backgroundColor = isSelected ? .systemMint : .white
    }
}
