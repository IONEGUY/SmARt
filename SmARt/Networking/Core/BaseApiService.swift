//
//  SmARtApp.swift
//  SmARt
//
//  Created by MacBook on 2/3/21.
//

import Foundation
import Alamofire
import Combine

class BaseApiService {
    private var errorHandler: ErrorHandler

    init(_ errorHandler: ErrorHandler) {
        self.errorHandler = errorHandler
    }

    func request<T: Codable> (_ urlRequestBuilder: URLRequestConvertible) -> AnyPublisher<T, APIError> {
        return AF.request(urlRequestBuilder)
            .publishDecodable(type: T.self)
            .value()
            .mapError(mapAFErrorToAppError)
            .receive(on: DispatchQueue.global(qos: .background))
            .retry(3)
            .share()
            .eraseToAnyPublisher()
    }
    
    private func mapAFErrorToAppError(_ afError: AFError) -> APIError {
        return .requestFailed
    }
}
