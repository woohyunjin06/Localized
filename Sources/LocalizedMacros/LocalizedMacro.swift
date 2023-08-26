//
//  LocalizedMacro.swift
//
//
//  Created by HyunJin on 2023/08/27.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct LocalizedMacro {}

extension LocalizedMacro: LocalizedMacroType {
    static let identifier = "Localized"
}

extension LocalizedMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let declaration = declaration.as(VariableDeclSyntax.self) else { return [] }
        guard let identifier = declaration.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else { return [] }
        guard let localizeKey = declaration.attributes.localizeKey(identifier: self.identifier) else {
            throw LocalizedDiagnostic.localizeKeyNotSpecified
        }
        
        let arguments = LocalizeArguments(viewName: identifier, localizeKey: localizeKey)
        
        let localizeSyntax = try FunctionDeclSyntax("func localize\(raw: identifier.firstUppercased)()") {
            IfExprSyntax(
                conditions: [
                    ConditionElementSyntax(
                        condition: .optionalBinding(
                            OptionalBindingConditionSyntax(
                                bindingSpecifier: "let",
                                pattern: IdentifierPatternSyntax(identifier: arguments.identifier)
                            )
                        )
                    )
                ]
            ) {
                FunctionCallExprSyntax(
                    callee: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: TokenSyntax("\(raw: identifier)")),
                        name: TokenSyntax("setLocalized")
                    )
                ) {
                    LabeledExprSyntax(
                        expression: FunctionCallExprSyntax(
                            callee: MemberAccessExprSyntax(
                                base: DeclReferenceExprSyntax(baseName: TokenSyntax("\(raw: localizeKey)")),
                                name: TokenSyntax("localized")
                            )
                        ) {
                            LabeledExprSyntax(
                                label: "arguments",
                                expression: DeclReferenceExprSyntax(baseName: arguments.identifier)
                            )
                        }
                    )
                }
            }
        }
        
        return [
            DeclSyntax(arguments.declaration),
            DeclSyntax(localizeSyntax)
        ]
    }
}
