
#if canImport(XCTest) && os(Linux)
import XCTest
@testable import QuotedPrintable

XCTMain([
    testCase(QuotedPrintableTests.allTests)
])
#endif
