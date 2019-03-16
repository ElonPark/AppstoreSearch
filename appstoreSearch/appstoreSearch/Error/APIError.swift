//
//  APIError.swift
//  appstoreSearch
//
//  Created by Elon on 17/03/2019.
//  Copyright © 2019 Elon. All rights reserved.
//

import Foundation

enum APIError: LocalizedError {
    case url
    case response
    case statusCode(Int)
    case responseData
    case jsonDecode
    
    var errorDescription: String? {
        switch self {
        case .url:
            return NSLocalizedString("URL을 생성할 수 없습니다.", comment: "URL Error")
        case .response:
            return NSLocalizedString("정상적인 응답이 아닙니다.", comment: "response Error")
        case .statusCode(let code):
                return NSLocalizedString("요청에 문제가 발생하였습니다. (ErrorCode: \(code)", comment: "response Error")
        case .responseData:
                return NSLocalizedString("데이터가 존재하지 않습니다.", comment: "Response Data Error")
        case .jsonDecode:
                return NSLocalizedString("JSON을 정상적으로 가져올 수 없습니다.", comment: "JSON Decode Error")
        }
    }
}
