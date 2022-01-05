//
//  String+Quotedprintable.swift
//  QuotedPrintable
//
//  Created by Johannes Schriewer on 13/12/15.
//  Copyright © 2015 Johannes Schriewer. All rights reserved.
//

// MARK: - Encoded

public extension String {
    
    /// Returns a quoted-printable encoded version of the string.
    func quotedPrintableEncoded() -> String {
        var characterCount = 0
        
        var encodedString = ""
        encodedString.reserveCapacity(count)
        
        let lineEnding = "=\r\n"
        
        return utf8.reduce(into: encodedString) { result, c in
            switch c {
            case 32...60, 62...126:
                characterCount += 1
                result.unicodeScalars.append(UnicodeScalar(c))
            case .carriageReturn:
                return
            case .newLine:
                if result.hasSuffix(" ") || result.hasSuffix("\t") {
                    result.append(lineEnding)
                    characterCount = 0
                } else {
                    result.append("\r\n")
                    characterCount = 0
                }
            default:
                if characterCount > 72 {
                    result.append(lineEnding)
                    characterCount = 0
                }
                
                result.append("=" + String(c, radix: 16).uppercased())
                characterCount += 3
            }
            
            if characterCount == 75 {
                characterCount = 0
                result.append(lineEnding)
            }
        }
    }
}

// MARK: - Decoded

public extension String {
    
    /// Returns a quoted-printable decoded version of the string.
    func quotedPrintableDecoded() -> String {
        var state = DecodeState.text

        var decodedString = ""
        decodedString.reserveCapacity(count)

        return utf8
            .compactMap { c in
                var parseResult: (c: UnicodeScalar?, state: DecodeState) = (c: nil, state: state)

                switch state {
                case .text:
                    parseResult = parseText(c)
                case .equals:
                    parseResult = parseEquals(c)
                case .equalsSecondDigit:
                    parseResult = parseEqualsSecondDigit(c, state: state)
                }

                state = parseResult.state
                return parseResult.c
            }
            .reduce(into: decodedString) { $0.unicodeScalars.append($1) }
    }
    
    private enum DecodeState {
        case text
        case equals
        case equalsSecondDigit(firstDigit: UInt8)
    }
    
    private func parseText(_ c: UInt8) -> (c: UnicodeScalar?, state: DecodeState) {
        if c == .equals {
            return (c: nil, state: .equals)
        }
        
        return (c: UnicodeScalar(c), state: .text)
    }
    
    private func parseEquals(_ c: UInt8) -> (c: UnicodeScalar?, state: DecodeState) {
        if c == .carriageReturn {
            return (c: nil, state: .equals)
        } else if c == .newLine {
            return (c: nil, state: .equals)
        } else if c.isNumberOrLetter {
            return (c: nil, state: .equalsSecondDigit(firstDigit: c))
        }
        
        return (c: UnicodeScalar(c), state: .text)
    }

    private func parseEqualsSecondDigit(
        _ c: UInt8,
        state: DecodeState
    ) -> (c: UnicodeScalar?, state: DecodeState) {
        if c.isNumberOrLetter {
            if case .equalsSecondDigit(let c0) = state {
                var result: UInt8 = 0
                if c0 <= 57 {
                    result = (c0 - 48) << 4
                } else if c0 <= 70 {
                    result = (c0 - 65 + 10) << 4
                } else {
                    result = (c0 - 97 + 10) << 4
                }
                
                if c <= 57 {
                    result += c - 48
                } else if c <= 70 {
                    result += c - 65 + 10
                } else {
                    result += c - 97 + 10
                }
                
                return (c: UnicodeScalar(result), state: .text)
            }
            return (c: nil, state: .text)
        }
        
        return (c: UnicodeScalar(c), state: .text)
    }
}

// MARK: -

private extension String.UTF8View.Element {
    
    static let newLine: Self = 10
    static let carriageReturn: Self = 13
    static let equals: Self = 61
    
    var isNumberOrLetter: Bool {
        // 0-9, A-F, a-f
        (48...57).contains(self) || (65...70).contains(self) || (97...102).contains(self)
    }
}
