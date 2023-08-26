//
//  LocalizedDiagnostic.swift
//
//
//  Created by HyunJin on 2023/08/26.
//

import SwiftDiagnostics

enum LocalizedDiagnostic: String, DiagnosticMessage, Error {
    case localizeKeyNotSpecified
    
    var message: String {
        switch self {
        case .localizeKeyNotSpecified:
            "`key` must be specified"
        }
    }
    
    var diagnosticID: MessageID {
        MessageID(domain: "LocalizedMacro", id: rawValue)
    }
    
    var severity: DiagnosticSeverity {
        switch self {
        case .localizeKeyNotSpecified: .error
        }
    }
}
