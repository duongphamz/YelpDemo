//
//  NetworkManager.swift
//  HomeTest
//
//  Created by Duong Pham on 13/02/2022.
//

import Foundation
import Moya
import RxSwift
import CoreLocation
protocol Networkable {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}

protocol NetworkManagerType {
    func searchBusiness(keyword: String, type: SearchType, location: CLLocationCoordinate2D?) -> Observable<SearchBusinessResponse>
    func getBusinessDetail(id: String) -> Observable<Business>
}

struct ApiManager: Networkable, NetworkManagerType {
    
    let provider = MoyaProvider<ApiRouter>(plugins: [NetworkLoggerPlugin()])
    
    private func sendRequestApi<T: Decodable>(request: ApiRouter) -> Observable<T> {
        Observable.create { observer in
            let request = provider.request(request) { result in
                switch result {
                case let .success(response):
                    do {
                        let data = try JSONDecoder().decode(T.self, from: response.data)
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
    
    func searchBusiness(keyword: String, type: SearchType, location: CLLocationCoordinate2D?) -> Observable<SearchBusinessResponse> {
        sendRequestApi(request: .searchBusiness(keyword: keyword, type: type, location: location))
    }
    
    func getBusinessDetail(id: String) -> Observable<Business> {
        sendRequestApi(request: .getBusinessDetail(id: id))
    }
    
}

