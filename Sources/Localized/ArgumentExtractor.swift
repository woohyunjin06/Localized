//
//  ArgumentExtractor.swift
//  
//
//  Created by HyunJin on 2023/08/24.
//

import Foundation

public protocol ArgumentExtracting {
    func extract<Arguments>(from arguments: Arguments) -> [CVarArg]
}

public struct ArgumentExtractor: ArgumentExtracting {
    public func extract<Arguments>(from arguments: Arguments) -> [CVarArg] {
        if let arguments = arguments as? CVarArg { return [arguments] }
        return Mirror(reflecting: arguments)
            .children
            .compactMap { $0.value as? CVarArg }
    }
}
