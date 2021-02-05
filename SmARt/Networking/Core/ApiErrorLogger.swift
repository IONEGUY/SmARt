//
//  SmARtApp.swift
//  SmARt
//
//  Created by MacBook on 2/3/21.
//

import Foundation
import Alamofire

class ApiErrorLogger: ErrorHandler {
    func handle(_ error: Error) {
        print(error)
    }
}
