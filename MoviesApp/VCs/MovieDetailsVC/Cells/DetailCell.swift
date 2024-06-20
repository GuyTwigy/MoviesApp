//
//  DetailCell.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellContent(title: String, description: String) {
        titleLbl.text = title
        descriptionLbl.text = description
    }
}
