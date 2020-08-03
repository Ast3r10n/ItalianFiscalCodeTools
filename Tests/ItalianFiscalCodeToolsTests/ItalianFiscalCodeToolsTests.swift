import XCTest
@testable import ItalianFiscalCodeTools

final class ItalianFiscalCodeToolsTests: XCTestCase {
  func testValidateFiscalCode() {
    XCTAssertNoThrow(try ItalianFiscalCodeTools.validateFiscalCode("RSSMRA73P08H501Q"))
    XCTAssertThrowsError(try ItalianFiscalCodeTools.validateFiscalCode("RSSMRA70P08H501Q"))
  }
}
