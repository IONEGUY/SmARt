//
//  SectionsService.swift
//  SmARt
//
//  Created by MacBook on 2/9/21.
//

import Foundation
import Combine

class MenuService: BaseApiService {
    func getSections() -> AnyPublisher<EnvironmentOut, APIError> {
        return request(URLRequestBuilder(.get, "api/open/environment/global_ios"))
    }
}
