//
//  AttributeListSyntax+LocalizeKey.swift
//  
//
//  Created by HyunJin on 2023/08/26.
//

import SwiftSyntax

extension AttributeListSyntax {
    func localizeKey(identifier: String) -> String? {
        lazy.compactMap { element -> String? in
            guard let syntax = element.as(AttributeSyntax.self) else { return nil }
            guard syntax.attributeName.as(IdentifierTypeSyntax.self)?.name.text == identifier else { return nil }
            return syntax.arguments?.as(LabeledExprListSyntax.self)?.first(
                where: { $0.label?.text == "key" }
            )?.expression.description
        }.first
    }
    
    var hasLocalizedAttribute: Bool {
        contains { element in
            guard let syntax = element.as(AttributeSyntax.self),
                  let name = syntax.attributeName.as(IdentifierTypeSyntax.self)?.name.text
            else { return false }
            return availableMacroIdentifiers.contains(name)
        }
    }
}
