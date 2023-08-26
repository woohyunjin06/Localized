//
//  Plugin.swift
//  
//
//  Created by HyunJin on 2023/08/23.
//

import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct LocalizedPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = availableMacros + [LocalizableMacro.self]
}
