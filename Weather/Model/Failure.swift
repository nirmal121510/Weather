//
//  Error.swift
//  Weather
//
//  Created by Nirmal's Macbook Pro on 29/04/22.
//

import Foundation

struct Error {
    
    let message: String
    
    init(_ code: ErrorCode) {
        switch code {
        case .serverError:
            message = "Server Error"
        case .parseError:
            message = "Parse Error"
        case .noData:
            message = "No Data"
        }
    }
}

enum ErrorCode {
    
    case serverError
    
    case parseError
    
    case noData
}
