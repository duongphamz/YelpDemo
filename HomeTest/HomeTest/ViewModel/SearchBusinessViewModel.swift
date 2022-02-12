//
//  SearchBusinessViewModel.swift
//  HomeTest
//
//  Created by Duong Pham on 12/02/2022.
//

import Foundation
import RxSwift

protocol SearchBusinessViewModelType {
    var searchTypes: BehaviorSubject<[SearchTypeViewModel]> { get }
    func fetchAllSearchTypes()
    func searchBusiness(keyword: String, type: SearchType)
    var presenter: SearchBusinessPresentable? { get set }
}

struct SearchBusinessViewModel: SearchBusinessViewModelType {
    
    let networkManager = NetworkManager()
    var presenter: SearchBusinessPresentable?
    var searchTypesData = [SearchTypeViewModel(isSelected: true, type: .businessName),
                           SearchTypeViewModel(isSelected: false, type: .location),
                           SearchTypeViewModel(isSelected: false, type: .cuisineType)]
    
    let searchTypes = BehaviorSubject<[SearchTypeViewModel]>(value: [])
    let disposeBag = DisposeBag()
    
    func fetchAllSearchTypes() {
        searchTypes.onNext(searchTypesData)
    }
    
    func searchBusiness(keyword: String, type: SearchType) {
        networkManager.searchBusiness(keyword: keyword)
            .subscribe(onNext: { response in
                guard let businesses = response.businesses else { return }
                print(businesses)
            }, onError: { error in
                print(error)
            }, onCompleted: {}, onDisposed: {
                
            })
            .disposed(by: disposeBag)
    }
}
