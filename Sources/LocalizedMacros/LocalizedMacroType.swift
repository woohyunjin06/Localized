//
//  LocalizedMacroType.swift
//
//
//  Created by HyunJin on 2023/08/27.
//

import SwiftSyntaxMacros

protocol LocalizedMacroType: Macro {
    static var identifier: String { get }
}

let availableMacros: [LocalizedMacroType.Type] = [
    LocalizedMacro.self,
    LocalizedButtonMacro.self
]

let availableMacroIdentifiers = availableMacros.map {
    $0.identifier
}
