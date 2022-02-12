//
//  ViewController.swift
//  HomeTest
//
//  Created by Duong Pham on 10/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchBusinessPresentable {
    func startLoadingIndicator()
    func endLoadingIndicator()
}

class SearchBusinessViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTypeCollectionView: UICollectionView!
    var viewModel: SearchBusinessViewModelType?
    
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        configureNavigationBar()
        configureCollectionView()
        configureSearchBar()
    }
    
    private func configureViewModel() {
        viewModel = SearchBusinessViewModel()
        viewModel?.presenter = self
        viewModel?.fetchAllSearchTypes()
    }
    
    private func configureNavigationBar() {
        title = "Search Business"
    }
    
    private func configureCollectionView() {
        searchTypeCollectionView.register(UINib(nibName: "SearchTypeCollectionViewCell",
                                                bundle: nil),
                                          forCellWithReuseIdentifier: SearchTypeCollectionViewCell.identifier)
        
        viewModel?
            .searchTypes
            .filter { !$0.isEmpty }
            .bind(to: searchTypeCollectionView.rx.items) {
              (collectionView: UICollectionView, index: Int, viewModel: SearchTypeViewModel) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchTypeCollectionViewCell.identifier, for: IndexPath(row: index, section: 0)) as! SearchTypeCollectionViewCell
                cell.configure(viewModel: viewModel)
              return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func configureSearchBar() {
        searchBar
            .rx
            .text
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let strongSelf = self, let keyword = text, !keyword.isEmpty else { return }
                strongSelf.viewModel?.searchBusiness(keyword: keyword, type: .businessName)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchBusinessViewController: SearchBusinessPresentable {
    
    func startLoadingIndicator() {
        
    }
    
    func endLoadingIndicator() {
        
    }
}
