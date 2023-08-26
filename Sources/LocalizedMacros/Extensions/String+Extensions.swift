//
//  String+Extensions.swift
//  
//
//  Created by HyunJin on 2023/08/27.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
}
