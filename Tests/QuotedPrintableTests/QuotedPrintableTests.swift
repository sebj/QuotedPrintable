//
//  encoder_decoder.swift
//  QuotedPrintable
//
//  Created by Johannes Schriewer on 13/12/15.
//  Copyright © 2015 Johannes Schriewer. All rights reserved.
//

#if canImport(XCTest)
import XCTest
@testable import QuotedPrintable

final class QuotedPrintableTests: XCTestCase {
    
    static let allTests = [
        ("testStringOfLettersEncoded", testStringOfLettersEncoded),
        ("testSpecialCharactersEncoded", testSpecialCharactersEncoded),
        ("testStringOfLettersDecoded", testStringOfLettersDecoded),
        ("testSpecialCharactersDecoded", testSpecialCharactersDecoded),
        ("testWhitespaceDecoded", testWhitespaceDecoded)
    ]
    
    func testStringOfLettersEncoded() {
        XCTAssertEqual("Hello World".quotedPrintableEncoded(), "Hello World")
    }
    
    func testSpecialCharactersEncoded() {
        XCTAssertEqual("e = m * c^2".quotedPrintableEncoded(), "e =3D m * c^2")
    }
    
    func testWhitespaceEncoded() {
        let actual = "Nullam id dolor id nibh ultricies vehicula ut id elit. Donec id elit non mi porta gravida at eget metus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam.".quotedPrintableEncoded()
        let expected = "Nullam id dolor id nibh ultricies vehicula ut id elit. Donec id elit non mi=\r\n porta gravida at eget metus. Lorem ipsum dolor sit amet, consectetur adipi=\r\nscing elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam."
        XCTAssertEqual(actual, expected)
    }
    
    // MARK: - Decoded
    
    func testStringOfLettersDecoded() {
        XCTAssertEqual("Hello World".quotedPrintableDecoded(), "Hello World")
    }
    
    func testSpecialCharactersDecoded() {
        XCTAssertEqual("e =3D m * c^2".quotedPrintableDecoded(), "e = m * c^2")
    }

    func testWhitespaceDecoded() {
        let actual = "Nullam id dolor id nibh ultricies vehicula ut id elit. Donec id elit non mi=\r\n porta gravida at eget metus. Lorem ipsum dolor sit amet, consectetur adipi=\r\nscing elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam.".quotedPrintableDecoded()
        let expected = "Nullam id dolor id nibh ultricies vehicula ut id elit. Donec id elit non mi porta gravida at eget metus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam."
        XCTAssertEqual(actual, expected)
    }
}

#endif
