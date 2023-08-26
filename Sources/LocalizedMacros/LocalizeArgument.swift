//
//  LocalizeArgument.swift
//
//
//  Created by HyunJin on 2023/08/27.
//

import SwiftSyntax

struct LocalizeArguments {
    let viewName: String
    let localizeKey: String
    
    var identifier: TokenSyntax {
        "\(raw: viewName)Arguments"
    }
    
    var declaration: VariableDeclSyntax {
        VariableDeclSyntax(
            bindingSpecifier: .keyword(.var)
        ) {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: identifier),
                initializer: InitializerClauseSyntax(
                    value: FunctionCallExprSyntax(
                        callee: DeclReferenceExprSyntax(baseName: TokenSyntax("makeNil"))
                    ) {
                        LabeledExprSyntax(
                            label: "ofType",
                            expression: DeclReferenceExprSyntax(baseName: "\(raw: localizeKey).argumentsType")
                        )
                    }
                ),
                accessorBlock: AccessorBlockSyntax(
                    accessors: .accessors(
                        AccessorDeclListSyntax {
                            AccessorDeclSyntax(accessorSpecifier: .identifier("didSet")) {
                                FunctionCallExprSyntax(callee: DeclReferenceExprSyntax(baseName: "localize\(raw: viewName.firstUppercased)"))
                            }
                        }
                    )
                )
            )
        }
    }
}
