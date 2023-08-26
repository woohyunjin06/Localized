//
//  ArgumentExtractorTests.swift
//
//
//  Created by HyunJin on 2023/08/27.
//

import Foundation
import XCTest
@testable import Localized

final class ArgumentExtractorTests: XCTestCase {
    
    var argumentExtractor: ArgumentExtracting!
    
    override func setUp() async throws {
        argumentExtractor = ArgumentExtractor()
    }
    
    override func tearDown() async throws {
        argumentExtractor = nil
    }

    func test_extract_when_argumentType_is_void() async throws {
        let argument: Void? = nil
        XCTAssert(argumentExtractor.extract(from: argument).isEmpty)
    }
    
    func test_extract_when_tuple_is_given() async throws {
        let arguments = (arg1: "Arg", arg2: 3)
        let extracted = argumentExtractor.extract(from: arguments)
        let isSame = extracted.elementsEqual(["Arg", 3]) { arg, element in
            arg as? Int == element as? Int || arg as? String == element as? String
        }
        XCTAssert(isSame)
    }
    
    func test_extract_when_single_argument_is_given() async throws {
        let arguments = "Arg"
        let extracted = argumentExtractor.extract(from: arguments)
        let isSame = extracted.elementsEqual(["Arg"]) { arg, element in
            arg as? String == element
        }
        XCTAssert(isSame)
    }
    
    func test_extract_when_argument_with_struct_type_is_given() async throws {
        struct Argument {
            let arg1: String
            let arg2: Int
        }
        
        let arguments = Argument(arg1: "Arg", arg2: 3)
        let extracted = argumentExtractor.extract(from: arguments)
        let isSame = extracted.elementsEqual(["Arg", 3]) { arg, element in
            arg as? Int == element as? Int || arg as? String == element as? String
        }
        XCTAssert(isSame)
    }
}
