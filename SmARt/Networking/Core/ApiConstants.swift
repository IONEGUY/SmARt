//
//  SmARtApp.swift
//  SmARt
//
//  Created by MacBook on 2/3/21.
//

import Foundation
import Alamofire

struct ApiConstants {
    static let baseUrl = "http://34.105.234.21:8080/"
    static let menuPath = "api/open/environment/global_ios"
    static let videosUrl = "\(baseUrl)api-video/open/video/download/"
    static let modelsUrl = "\(baseUrl)api-files/open/file/download/"

    struct Parameters {

    }

    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }

    enum ContentType: String {
        case json = "application/json"
    }
}
