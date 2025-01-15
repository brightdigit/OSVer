import XCTest

@testable import OSVer

final class OSVerBasicTests: XCTestCase {
  // MARK: - Initialization Tests

  func testInitWithVersionStyle() {
    let version = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    XCTAssertEqual(version.majorVersion, 1)
    XCTAssertEqual(version.minorVersion, 2)
    XCTAssertEqual(version.patchVersion, 3)
  }

  func testInitWithOperatingSystemVersion() {
    let osVersion = OperatingSystemVersion(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    let version = OSVer(osVersion)
    XCTAssertEqual(version.majorVersion, 1)
    XCTAssertEqual(version.minorVersion, 2)
    XCTAssertEqual(version.patchVersion, 3)
  }

  // MARK: - Array Initialization Tests

  func testInitWithArray() throws {
    // Test with 3 elements
    let version1 = try OSVer(array: [1, 2, 3])
    XCTAssertEqual(version1.majorVersion, 1)
    XCTAssertEqual(version1.minorVersion, 2)
    XCTAssertEqual(version1.patchVersion, 3)

    // Test with 2 elements
    let version2 = try OSVer(array: [1, 2])
    XCTAssertEqual(version2.majorVersion, 1)
    XCTAssertEqual(version2.minorVersion, 2)
    XCTAssertEqual(version2.patchVersion, 0)
  }

  func testInitWithInvalidArrayThrows() {
    // Test with 1 element
    XCTAssertThrowsError(try OSVer(array: [1])) { error in
      XCTAssertTrue(error is OSVer.ParsingError)
      XCTAssertEqual(error as? OSVer.ParsingError, .invalidArrayLength)
    }

    // Test with 4 elements
    XCTAssertThrowsError(try OSVer(array: [1, 2, 3, 4])) { error in
      XCTAssertTrue(error is OSVer.ParsingError)
      XCTAssertEqual(error as? OSVer.ParsingError, .invalidArrayLength)
    }

    // Test with empty array
    XCTAssertThrowsError(try OSVer(array: [])) { error in
      XCTAssertTrue(error is OSVer.ParsingError)
      XCTAssertEqual(error as? OSVer.ParsingError, .invalidArrayLength)
    }
  }

  // MARK: - OSVerParseable Tests

  func testParseableString() throws {
    let version1 = try OSVer(parsing: "1.2.3")
    XCTAssertEqual(version1.majorVersion, 1)
    XCTAssertEqual(version1.minorVersion, 2)
    XCTAssertEqual(version1.patchVersion, 3)

    let version2 = try OSVer(parsing: "1.2")
    XCTAssertEqual(version2.majorVersion, 1)
    XCTAssertEqual(version2.minorVersion, 2)
    XCTAssertEqual(version2.patchVersion, 0)
  }

  func testParseableArray() throws {
    let version1 = try OSVer(parsing: [1, 2, 3])
    XCTAssertEqual(version1.majorVersion, 1)
    XCTAssertEqual(version1.minorVersion, 2)
    XCTAssertEqual(version1.patchVersion, 3)

    let version2 = try OSVer(parsing: [1, 2])
    XCTAssertEqual(version2.majorVersion, 1)
    XCTAssertEqual(version2.minorVersion, 2)
    XCTAssertEqual(version2.patchVersion, 0)
  }

  func testParseableInvalidInputs() {
    XCTAssertThrowsError(try OSVer(parsing: "1.x.3"))
    XCTAssertThrowsError(try OSVer(parsing: "invalid"))
    XCTAssertThrowsError(try OSVer(parsing: [1]))
    XCTAssertThrowsError(try OSVer(parsing: [1, 2, 3, 4]))
  }

  // MARK: - String Parsing Tests

  func testInitWithValidString() throws {
    let version = try OSVer(string: "1.2.3")
    XCTAssertEqual(version.majorVersion, 1)
    XCTAssertEqual(version.minorVersion, 2)
    XCTAssertEqual(version.patchVersion, 3)
  }

  func testInitWithValidStringNoPatch() throws {
    let version = try OSVer(string: "1.2")
    XCTAssertEqual(version.majorVersion, 1)
    XCTAssertEqual(version.minorVersion, 2)
    XCTAssertEqual(version.patchVersion, 0)
  }

  func testInitWithInvalidFormatThrows() {
    // Test with single number
    XCTAssertThrowsError(try OSVer(string: "1")) { error in
      XCTAssertTrue(error is OSVer.ParsingError)
      XCTAssertEqual(error as? OSVer.ParsingError, .invalidArrayLength)
    }

    // Test with four numbers
    XCTAssertThrowsError(try OSVer(string: "1.2.3.4")) { error in
      XCTAssertTrue(error is OSVer.ParsingError)
      XCTAssertEqual(error as? OSVer.ParsingError, .invalidArrayLength)
    }
  }

  func testInitWithInvalidNumbersThrows() {
    XCTAssertThrowsError(try OSVer(string: "1.x.3")) { error in
      XCTAssertTrue(error is OSVer.ParsingError)
      XCTAssertEqual(error as? OSVer.ParsingError, .invalidFormat)
    }

    XCTAssertThrowsError(try OSVer(string: "a.b")) { error in
      XCTAssertTrue(error is OSVer.ParsingError)
      XCTAssertEqual(error as? OSVer.ParsingError, .invalidFormat)
    }
  }

  // MARK: - Codable Tests

  func testEncodingAsObject() throws {
    let version = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    let encoder = JSONEncoder()
    encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.object

    let data = try encoder.encode(version)
    let json = try JSONSerialization.jsonObject(with: data) as! [String: Int]

    XCTAssertEqual(json["majorVersion"], 1)
    XCTAssertEqual(json["minorVersion"], 2)
    XCTAssertEqual(json["patchVersion"], 3)
  }

  func testEncodingAsString() throws {
    let version = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    let encoder = JSONEncoder()
    encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.string

    let data = try encoder.encode(version)
    let string = String(data: data, encoding: .utf8)!.trimmingCharacters(
      in: CharacterSet(charactersIn: "\""))

    XCTAssertEqual(string, "1.2.3")
  }

  func testEncodingAsArray() throws {
    let version = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    let encoder = JSONEncoder()
    encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.array

    let data = try encoder.encode(version)
    let array = try JSONSerialization.jsonObject(with: data) as! [Int]

    XCTAssertEqual(array, [1, 2, 3])
  }

  func testDecodingFromObject() throws {
    let json = """
      {
          "majorVersion": 1,
          "minorVersion": 2,
          "patchVersion": 3
      }
      """.data(using: .utf8)!

    let version = try JSONDecoder().decode(OSVer.self, from: json)
    XCTAssertEqual(version.majorVersion, 1)
    XCTAssertEqual(version.minorVersion, 2)
    XCTAssertEqual(version.patchVersion, 3)
  }

  func testDecodingFromObjectWithoutPatch() throws {
    let json = """
      {
          "majorVersion": 1,
          "minorVersion": 2
      }
      """.data(using: .utf8)!

    let version = try JSONDecoder().decode(OSVer.self, from: json)
    XCTAssertEqual(version.majorVersion, 1)
    XCTAssertEqual(version.minorVersion, 2)
    XCTAssertEqual(version.patchVersion, 0)
  }

  func testDecodingFromString() throws {
    let json = "\"1.2.3\"".data(using: .utf8)!

    let version = try JSONDecoder().decode(OSVer.self, from: json)
    XCTAssertEqual(version.majorVersion, 1)
    XCTAssertEqual(version.minorVersion, 2)
    XCTAssertEqual(version.patchVersion, 3)
  }

  func testDecodingFromStringWithoutPatch() throws {
    let json = "\"1.2\"".data(using: .utf8)!

    let version = try JSONDecoder().decode(OSVer.self, from: json)
    XCTAssertEqual(version.majorVersion, 1)
    XCTAssertEqual(version.minorVersion, 2)
    XCTAssertEqual(version.patchVersion, 0)
  }

  func testDecodingFromArray() throws {
    // Test with 3 elements
    let json1 = "[1, 2, 3]".data(using: .utf8)!
    let version1 = try JSONDecoder().decode(OSVer.self, from: json1)
    XCTAssertEqual(version1.majorVersion, 1)
    XCTAssertEqual(version1.minorVersion, 2)
    XCTAssertEqual(version1.patchVersion, 3)

    // Test with 2 elements
    let json2 = "[1, 2]".data(using: .utf8)!
    let version2 = try JSONDecoder().decode(OSVer.self, from: json2)
    XCTAssertEqual(version2.majorVersion, 1)
    XCTAssertEqual(version2.minorVersion, 2)
    XCTAssertEqual(version2.patchVersion, 0)
  }

  func testDecodingFromInvalidArrayLength() {
    // Test with 1 element
    XCTAssertThrowsError(try JSONDecoder().decode(OSVer.self, from: "[1]".data(using: .utf8)!))

    // Test with 4 elements
    XCTAssertThrowsError(
      try JSONDecoder().decode(OSVer.self, from: "[1, 2, 3, 4]".data(using: .utf8)!))

    // Test with empty array
    XCTAssertThrowsError(try JSONDecoder().decode(OSVer.self, from: "[]".data(using: .utf8)!))
  }

  // MARK: - Equatable Tests

  func testEquality() {
    let version1 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    let version2 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    let version3 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 4)

    XCTAssertEqual(version1, version2)
    XCTAssertNotEqual(version1, version3)
  }

  // MARK: - Hashable Tests

  func testHashable() {
    let version1 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    let version2 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    let version3 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 4)

    var set = Set<OSVer>()
    set.insert(version1)
    set.insert(version2)  // Should not increase size
    set.insert(version3)

    XCTAssertEqual(set.count, 2)
  }

  func testHashConsistency() {
    let version1 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    let version2 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)

    XCTAssertEqual(version1.hashValue, version2.hashValue)
  }

  // MARK: - Comparable Tests

  func testComparable() {
    let version1 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    let version2 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 4)
    let version3 = OSVer(majorVersion: 1, minorVersion: 3, patchVersion: 0)
    let version4 = OSVer(majorVersion: 2, minorVersion: 0, patchVersion: 0)

    XCTAssertLessThan(version1, version2)
    XCTAssertLessThan(version2, version3)
    XCTAssertLessThan(version3, version4)

    // Test greater than
    XCTAssertGreaterThan(version4, version3)
    XCTAssertGreaterThan(version3, version2)
    XCTAssertGreaterThan(version2, version1)
  }

  func testComparableDefaultPatch() {
    let version1 = OSVer(majorVersion: 1, minorVersion: 2)
    let version2 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 0)
    let version3 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 1)

    XCTAssertEqual(version1, version2)
    XCTAssertLessThan(version1, version3)
  }

  // MARK: - Description Tests

  func testDescription() {
    let version = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
    XCTAssertEqual(version.description, "1.2.3")

    let versionNoPatch = OSVer(majorVersion: 1, minorVersion: 2)
    XCTAssertEqual(versionNoPatch.description, "1.2.0")
  }
}
