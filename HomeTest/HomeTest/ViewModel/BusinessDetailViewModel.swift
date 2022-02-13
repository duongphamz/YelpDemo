//
//  BusinessDetailViewModel.swift
//  HomeTest
//
//  Created by Duong Pham on 13/02/2022.
//

import Foundation
import RxSwift

protocol BusinessDetailViewModelType {
    var businessDetail: BehaviorSubject<[BusinessInfoViewModel]> { get }
    var businessImage: BehaviorSubject<String?> { get }
    func fetchBusinessDetail()
    
}

class BusinessDetailViewModel: BusinessDetailViewModelType {
    let disposeBag = DisposeBag()
    let networkManager: NetworkManagerType = ApiManager()
    let businessDetail = BehaviorSubject<[BusinessInfoViewModel]>(value: [])
    var businessImage = BehaviorSubject<String?>(value: nil)
    
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    func fetchBusinessDetail() {
        
        networkManager.getBusinessDetail(id: id)
            .subscribe(onNext: { [weak self] detail in
                guard let strongSelf = self else { return }
                let viewModels = strongSelf.convertDataToViewModel(business: detail)
                strongSelf.businessImage.onNext(detail.imageUrl)
                strongSelf.businessDetail.onNext(viewModels)
                
            }, onError: { [weak self] error in
                print(error)
                guard let strongSelf = self else { return }
                strongSelf.businessDetail.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func convertDataToViewModel(business: Business) -> [BusinessInfoViewModel] {
        var viewModels: [BusinessInfoViewModel] = []
        
        let nameSection = BusinessInfoViewModel(title: "Name", description: business.name)
        
        let addressLocation = BusinessInfoViewModel(title: "Address", description: business.location?.displayAddress?.joined(separator: ","))
        
        let categorySection = BusinessInfoViewModel(title: "Category", description: business.categories?.compactMap { $0.title }.joined(separator: ","))
        
        let openTime = (business.hours?.first?.open?.first?.start) ?? ""
        let closeTime = (business.hours?.first?.open?.first?.end) ?? ""
        let operationTime = openTime + "-" + closeTime
        let hoursOperationSection = BusinessInfoViewModel(title: "Hours of operation", description: operationTime)
        
        let ratingSection = BusinessInfoViewModel(title: "Rating", description: String(business.rating ?? 0))
        
        viewModels.append(nameSection)
        viewModels.append(addressLocation)
        viewModels.append(categorySection)
        viewModels.append(hoursOperationSection)
        viewModels.append(ratingSection)
        
        return viewModels
    }
}
