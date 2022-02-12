//
//  NetworkManager.swift
//  HomeTest
//
//  Created by Duong Pham on 13/02/2022.
//

import Foundation
import Moya
import RxSwift

protocol Networkable {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}

struct NetworkManager: Networkable {
    let key = ""
    let provider = MoyaProvider<BusinessApi>(plugins: [NetworkLoggerPlugin()])
    
    func searchBusiness(keyword: String) -> Observable<SearchBusinessResponse> {
        Observable.create { observer in
            let request = provider.request(.searchBusiness(keyword: keyword)) { result in
                switch result {
                case let .success(response):
                    do {
                        let data = try JSONDecoder().decode(SearchBusinessResponse.self, from: response.data)
                        return observer.onNext(data)
                    } catch let err {
                        observer.onError(err)
                    }
                case let .failure(error):
                    return observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
        
    }
    
}

