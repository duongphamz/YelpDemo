//
//  SearchTypeCollectionViewCell.swift
//  HomeTest
//
//  Created by Duong Pham on 12/02/2022.
//

import UIKit

enum SearchType {
    case businessName
    case location
    case cuisineType
    
    var displayTitle: String {
        switch self {
        case .businessName:
            return "Business name"
        case .location:
            return "Location"
        case .cuisineType:
            return "Cuisine type"
        }
    }
}

struct SearchTypeViewModel {
    var isSelected: Bool
    let type: SearchType
    
    init(isSelected: Bool, type: SearchType) {
        self.isSelected = isSelected
        self.type = type
    }
}

class SearchTypeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "searchTypeCollectionViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    private func configureView() {
        
        containerView.layer.cornerRadius = 20
    }
    
    private func configureSelectedState() {
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(hexString: "#2F6BFF").cgColor
        containerView.backgroundColor = UIColor.white
    }
    
    private func configureNormalState() {
        containerView.layer.borderWidth = 0
        containerView.backgroundColor = UIColor(hexString: "#F2F3F4")
    }
    
    public func configure(viewModel: SearchTypeViewModel) {
        searchTypeLabel.text = viewModel.type.displayTitle
        
        if viewModel.isSelected {
            configureSelectedState()
            return
        }
        configureNormalState()
    }
}
