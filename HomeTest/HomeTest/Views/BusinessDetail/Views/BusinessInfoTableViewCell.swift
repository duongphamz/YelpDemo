//
//  BusinessInfoTableViewCell.swift
//  HomeTest
//
//  Created by Duong Pham on 13/02/2022.
//

import UIKit
struct BusinessInfoViewModel {
    let title: String
    let description: String
    init(title: String?, description: String?) {
        self.title = title ?? ""
        self.description = description ?? ""
    }
}
class BusinessInfoTableViewCell: UITableViewCell {
    static let identifier = "businessInfoTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(viewModel: BusinessInfoViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}
