//
//  LocalizedButtonMacro.swift
//
//
//  Created by HyunJin on 2023/08/27.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct LocalizedButtonMacro {}

extension LocalizedButtonMacro: LocalizedMacroType {
    static let identifier = "LocalizedButton"
}

extension LocalizedButtonMacro: PeerMacro {
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
        guard let targetStateExpression = targetStateExpression(from: declaration.attributes) else { return [] }
        
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
                        name: TokenSyntax("setTitle")
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
                    LabeledExprSyntax(
                        label: "for",
                        expression: targetStateExpression
                    )
                }
            }
        }
        
        return [
            DeclSyntax(arguments.declaration),
            DeclSyntax(localizeSyntax)
        ]
    }
    
    private static func targetStateExpression(from attributes: AttributeListSyntax) -> ExprSyntax? {
        attributes.lazy.compactMap { element -> ExprSyntax? in
            guard let syntax = element.as(AttributeSyntax.self) else { return nil }
            guard syntax.attributeName.as(IdentifierTypeSyntax.self)?.name.text == self.identifier else { return nil }
            return syntax.arguments?.as(LabeledExprListSyntax.self)?.first(
                where: { syntax in
                    syntax.label?.text == "for"
                }
            )?.as(LabeledExprSyntax.self)?.expression
        }.first
    }
}
