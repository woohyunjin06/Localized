//
//  LocalizableView.swift
//
//
//  Created by HyunJin on 2023/08/27.
//

import Foundation

public protocol LocalizableView {
    func setLocalized(_ text: String)
}

#if canImport(UIKit)
public extension UILabel: LocalizableView {
    func setLocalized(_ text: String) {
        self.text = text
    }
}
#endif

#if canImport(AppKit)
import AppKit
extension NSTextField: LocalizableView {
    public func setLocalized(_ text: String) {
        self.stringValue = text
    }
}
#endif
