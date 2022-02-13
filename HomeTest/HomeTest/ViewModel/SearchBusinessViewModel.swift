//
//  SearchBusinessViewModel.swift
//  HomeTest
//
//  Created by Duong Pham on 12/02/2022.
//

import Foundation
import RxSwift
import CoreLocation

protocol SearchBusinessViewModelType {
    var searchTypes: BehaviorSubject<[SearchTypeViewModel]> { get }
    var businessSearchResults: BehaviorSubject<[BusinessTableViewCellViewModel]> { get }
    var presenter: SearchBusinessPresentable? { get set }
    mutating func requestLocationPermisson()
    func fetchAllSearchTypes()
    func searchBusiness(keyword: String)
    func updateCurrentSearchType(type: SearchType)
}

class SearchBusinessViewModel: SearchBusinessViewModelType {
    
    let networkManager: NetworkManagerType = ApiManager()
    let locationService: LocationServiceType = LocationService()
    var lastLocation: CLLocation?
    
    var currentSearchType: SearchType? {
        return self.searchTypesData.first(where: { $0.isSelected == true })?.type
    }
    var presenter: SearchBusinessPresentable?
    var searchTypesData = [SearchTypeViewModel(isSelected: true, type: .businessName),
                           SearchTypeViewModel(isSelected: false, type: .location),
                           SearchTypeViewModel(isSelected: false, type: .cuisineType)]
    
    let searchTypes = BehaviorSubject<[SearchTypeViewModel]>(value: [])
    let businessSearchResults = BehaviorSubject<[BusinessTableViewCellViewModel]>(value: [])
    let disposeBag = DisposeBag()
    
    func fetchAllSearchTypes() {
        searchTypes.onNext(searchTypesData)
    }
    
    func updateCurrentSearchType(type: SearchType) {
        searchTypesData.indices.forEach {
            searchTypesData[$0].isSelected = searchTypesData[$0].type == type
        }
        searchTypes.onNext(searchTypesData)
    }
    
    func searchBusiness(keyword: String) {
        guard let type = currentSearchType else { return }
        presenter?.startLoadingIndicator()
        networkManager.searchBusiness(keyword: keyword, type: type, location: lastLocation?.coordinate)
            .subscribe(onNext: { [weak self] response in
                guard let strongSelf = self else { return }
                strongSelf.presenter?.endLoadingIndicator()
                let convertedData = response.businesses.compactMap { BusinessTableViewCellViewModel(id: $0.id, imageUrl: $0.imageUrl, name: $0.name, location: $0.location?.city) }
                strongSelf.businessSearchResults.onNext(convertedData)
                
            }, onError: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.presenter?.endLoadingIndicator()
                strongSelf.businessSearchResults.onNext([])
            })
            .disposed(by: disposeBag)
    }
    
    func requestLocationPermisson() {
        configureLocation()
        locationService.requestPermission()
    }
    
    func configureLocation() {
        locationService.lastLocation
            .subscribe(onNext: { [weak self] location in
                guard let strongSelf = self else { return }
                strongSelf.lastLocation = location
            })
            .disposed(by: disposeBag)
    }
}
