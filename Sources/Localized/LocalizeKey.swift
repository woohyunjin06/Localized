//
//  LocalizeKey.swift
//
//
//  Created by HyunJin on 2023/08/23.
//

import Foundation

public struct LocalizeKey<Arguments> {
    public let key: String
    public let argumentsType: Arguments.Type
    
    public init(
        key: String,
        argumentsType: Arguments.Type = Void.self
    ) {
        self.key = key
        self.argumentsType = argumentsType
    }
    
    public func localized(arguments: Arguments) -> String {
        String(
            format: NSLocalizedString(key, comment: key),
            ArgumentExtractor().extract(from: arguments)
        )
    }
}

extension LocalizeKey where Arguments == Void {
    public func localized() -> String {
        localized(arguments: Void())
    }
}

public func makeNil<T>(ofType: T.Type) -> T? { nil }
