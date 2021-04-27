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
    static let imagesUrl = "\(baseUrl)api-image/open/image/download/"
    
    static let fileUrls: [AugmentedObjectType : String] = [
        .image: ApiConstants.imagesUrl,
        .object3D: ApiConstants.modelsUrl,
        .video: ApiConstants.videosUrl
    ]
    
    static let fileExtensions: [AugmentedObjectType : String] = [
        .image: "png",
        .object3D: "usdz",
        .video: "mp4"
    ]

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
