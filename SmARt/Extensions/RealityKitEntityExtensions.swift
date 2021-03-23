//
//  RealityKitEntityExtensions.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//

import Foundation
import RealityKit
import Alamofire

extension Entity {
    static func loadModelAsync(url: String) -> LoadRequest<ModelEntity> {
        AF.download(url, method: .get).responseData { response in
            guard let filePath = FileManager.default.urls(
                for: .cachesDirectory,
                in: .userDomainMask).first?.appendingPathComponent("\(url).usdz"),
                (try? response.result.get().write(to: filePath)) != nil else { return }

            return Entity.loadModelAsync(contentsOf: filePath)
        }
    }
}
