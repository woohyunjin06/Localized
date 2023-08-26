//
//  LocalizableMacro.swift
//
//
//  Created by HyunJin on 2023/08/26.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct LocalizableMacro {}

extension LocalizableMacro: MemberMacro {
    public static func expansion<
        Declaration: DeclGroupSyntax,
        Context: MacroExpansionContext
    >(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        let members = declaration.memberBlock.members
        let localizeCalls = members.compactMap { member -> FunctionCallExprSyntax? in
            guard let syntax = member.decl.as(VariableDeclSyntax.self) else { return nil }
            guard let identifier = syntax.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else { return nil }
            guard syntax.attributes.hasLocalizedAttribute else { return nil }
            return FunctionCallExprSyntax(
                callee: DeclReferenceExprSyntax(baseName: TokenSyntax("localize\(raw: identifier.firstUppercased)"))
            )
        }
        
        let functionDecl = try FunctionDeclSyntax("func localize()") {
            for call in localizeCalls {
                call
            }
        }
        
        return [DeclSyntax(functionDecl)]
    }
}
