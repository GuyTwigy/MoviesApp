//
//  DetailTrailerShareCell.swift
//  MoviesApp
//
//  Created by Guy Twig on 20/06/2024.
//

import UIKit

import UIKit

protocol DetailTrailerShareCellDelegate: AnyObject {
    func showTrailerTapped()
    func shareTapped()
}

class DetailTrailerShareCell: UITableViewCell {

    weak var delegate: DetailTrailerShareCellDelegate?
    
    @IBOutlet weak var notAvailableLbl: UILabel!
    @IBOutlet weak var showTrailerBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellContent(isVideo: Bool) {
//        notAvailableLbl.isHidden = isVideo
        showTrailerBtn.isHidden = false
    }
    
    @IBAction func showTrailerTapped(_ sender: Any) {
        delegate?.showTrailerTapped()
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        delegate?.shareTapped()
    }
}

