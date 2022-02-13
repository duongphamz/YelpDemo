//
//  BusinessDetailViewController.swift
//  HomeTest
//
//  Created by Duong Pham on 13/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class BusinessDetailViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    var viewModel: BusinessDetailViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configurePresenter()
        fetchBusinessDetailData()
    }
    
    private func configureView() {
        tableView.register(UINib(nibName: String(describing: BusinessInfoTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: BusinessInfoTableViewCell.identifier)
        tableView.tableFooterView = UIView()
    }
    
    private func configurePresenter() {
        
        viewModel?
            .businessDetail
            .bind(to: tableView.rx.items) {
              (tableView: UITableView, index: Int, viewModel: BusinessInfoViewModel) in
                let cell = tableView.dequeueReusableCell(withIdentifier: BusinessInfoTableViewCell.identifier, for: IndexPath(row: index, section: 0)) as! BusinessInfoTableViewCell
                cell.configure(viewModel: viewModel)
              return cell
            }
            .disposed(by: disposeBag)
        
        viewModel?.businessImage
            .subscribe(onNext: { [weak self] imageUrl in
                guard let strongSelf = self, let url = imageUrl else { return }
                strongSelf.logoImageView.kf.setImage(with: URL(string: url))
            })
            .disposed(by: disposeBag)
            
    }
    private func fetchBusinessDetailData() {
        viewModel?.fetchBusinessDetail()
    }
}
