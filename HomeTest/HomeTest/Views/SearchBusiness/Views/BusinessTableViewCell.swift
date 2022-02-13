//
//  BusinessTableViewCell.swift
//  HomeTest
//
//  Created by Duong Pham on 13/02/2022.
//

import UIKit
import Kingfisher

struct BusinessTableViewCellViewModel {
    let id: String?
    let imageUrl: String?
    let name: String?
    let location: String?
}

class BusinessTableViewCell: UITableViewCell {
    static let identifier = "businessTableViewCell"
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(viewModel: BusinessTableViewCellViewModel) {
        if let imageUrl = viewModel.imageUrl {
            self.logoImageView.kf.setImage(with: URL(string: imageUrl))
        }
        nameLabel.text = viewModel.name
        locationLabel.text = viewModel.location
    }
}
