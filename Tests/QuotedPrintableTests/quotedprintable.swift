//
//  encoder_decoder.swift
//  unchained
//
//  Created by Johannes Schriewer on 13/12/15.
//  Copyright © 2015 Johannes Schriewer. All rights reserved.
//

#if canImport(XCTest)
import XCTest
@testable import QuotedPrintable

class quotedPrintableTests: XCTestCase {
    
    func testQuotedPrintableEncode() throws {
        var encoded = QuotedPrintable.encode(string: "Hello World")
        XCTAssert(encoded == "Hello World")
        
        encoded = QuotedPrintable.encode(string: "e = m * c^2")
        XCTAssert(encoded == "e =3D m * c^2")
        
        encoded = QuotedPrintable.encode(string: "Nullam id dolor id nibh ultricies vehicula ut id elit. Donec id elit non mi porta gravida at eget metus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam.")
        XCTAssert(encoded == "Nullam id dolor id nibh ultricies vehicula ut id elit. Donec id elit non mi=\r\n porta gravida at eget metus. Lorem ipsum dolor sit amet, consectetur adipi=\r\nscing elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam.")
    }

    func testQuotedPrintableDecode() throws {
        var decoded = QuotedPrintable.decode(string: "Hello World")
        XCTAssert(decoded == "Hello World")
     
        decoded = QuotedPrintable.decode(string: "e =3D m * c^2")
        XCTAssert(decoded == "e = m * c^2")
        
        decoded = QuotedPrintable.decode(string: "Nullam id dolor id nibh ultricies vehicula ut id elit. Donec id elit non mi=\r\n porta gravida at eget metus. Lorem ipsum dolor sit amet, consectetur adipi=\r\nscing elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam.")
        XCTAssert(decoded == "Nullam id dolor id nibh ultricies vehicula ut id elit. Donec id elit non mi porta gravida at eget metus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam.")
    }
}

#if os(Linux)
extension quotedPrintableTests {
    static var allTests : [(String, (quotedPrintableTests) -> () throws -> Void)] {
        return [
            ("testQuotedPrintableEncode", testQuotedPrintableEncode),
            ("testQuotedPrintableDecode", testQuotedPrintableDecode)
        ]
    }

}
#endif
#endif
