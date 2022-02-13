//
//  ViewController.swift
//  HomeTest
//
//  Created by Duong Pham on 10/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

protocol SearchBusinessPresentable {
    func startLoadingIndicator()
    func endLoadingIndicator()
}

class SearchBusinessViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTypeCollectionView: UICollectionView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyLabel: UILabel!
    var viewModel: SearchBusinessViewModelType?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureViewModel()
        configureNavigationBar()
        configureCollectionView()
        configureSearchBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedCellIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedCellIndexPath, animated: true)
        }
    }
    
    private func configureView() {
        loadingIndicatorView.isHidden = true
    }
    
    private func configureViewModel() {
        viewModel = SearchBusinessViewModel()
        viewModel?.presenter = self
        viewModel?.fetchAllSearchTypes()
        viewModel?.requestLocationPermisson()
    }
    
    private func configureNavigationBar() {
        title = "Search Business"
    }
    
    private func configureCollectionView() {
        searchTypeCollectionView.register(UINib(nibName: String(describing: SearchTypeCollectionViewCell.self),
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
        
        searchTypeCollectionView
            .rx
            .modelSelected(SearchTypeViewModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let strongSelf = self else { return }
                strongSelf.viewModel?.updateCurrentSearchType(type: model.type)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: String(describing: BusinessTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: BusinessTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        
        viewModel?
            .businessSearchResults
            .bind(to: tableView.rx.items) {
              (tableView: UITableView, index: Int, viewModel: BusinessTableViewCellViewModel) in
                let cell = tableView.dequeueReusableCell(withIdentifier: BusinessTableViewCell.identifier, for: IndexPath(row: index, section: 0)) as! BusinessTableViewCell
                cell.configure(viewModel: viewModel)
              return cell
            }
            .disposed(by: disposeBag)
        
        viewModel?
            .businessSearchResults
            .skip(1)
            .map { !$0.isEmpty }
            .bind(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(BusinessTableViewCellViewModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let strongSelf = self, let id = model.id else { return }
                strongSelf.navigateToBusinessDetailScreen(id: id)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureSearchBar() {
        searchBar.returnKeyType = .done
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.searchBar.resignFirstResponder()
        })
        .disposed(by: disposeBag)
        
        searchBar
            .rx
            .text
            .orEmpty
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyword in
                guard let strongSelf = self else { return }
                strongSelf.viewModel?.searchBusiness(keyword: keyword)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text.filter {($0?.isEmpty) ?? true}
            .subscribe(onNext: { [weak self] text in
                guard let strongSelf = self else { return }
                strongSelf.endLoadingIndicator()
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToBusinessDetailScreen(id: String) {
        if let businessDetailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessDetailViewController") as? BusinessDetailViewController {
            let businessDetailViewModel = BusinessDetailViewModel(id: id)
            businessDetailVC.viewModel = businessDetailViewModel
            navigationController?.pushViewController(businessDetailVC, animated: true)
        }
    }
}

extension SearchBusinessViewController: SearchBusinessPresentable {
    
    func startLoadingIndicator() {
        loadingIndicatorView.isHidden = false
        loadingIndicatorView.startAnimating()
    }
    
    func endLoadingIndicator() {
        loadingIndicatorView.stopAnimating()
        loadingIndicatorView.isHidden = true
    }
}
