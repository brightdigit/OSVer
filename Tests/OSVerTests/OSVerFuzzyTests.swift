//
//  OSVerFuzzyTests.swift
//  OSVer
//
//  Created by Leo Dion on 1/15/25.
//

import XCTest

@testable import OSVer

final class OSVerFuzzyTests: XCTestCase {
  // MARK: - Fuzzy Initialization Tests

  func testFuzzyInitialization() {
    for _ in 0..<1000 {
      let majorVersion = Int.random(in: 0...100)
      let minorVersion = Int.random(in: 0...100)
      let patchVersion = Int.random(in: 0...100)

      let version = OSVer(
        majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion)
      XCTAssertEqual(version.majorVersion, majorVersion)
      XCTAssertEqual(version.minorVersion, minorVersion)
      XCTAssertEqual(version.patchVersion, patchVersion)
    }
  }

  // MARK: - Fuzzy Array Tests

  func testFuzzyArrayInitialization() {
    for _ in 0..<1000 {
      let majorVersion = Int.random(in: 0...100)
      let minorVersion = Int.random(in: 0...100)
      let patchVersion = Int.random(in: 0...100)

      // Test with 3 elements
      let version1 = try? OSVer(array: [majorVersion, minorVersion, patchVersion])
      XCTAssertNotNil(version1)
      XCTAssertEqual(version1?.majorVersion, majorVersion)
      XCTAssertEqual(version1?.minorVersion, minorVersion)
      XCTAssertEqual(version1?.patchVersion, patchVersion)

      // Test with 2 elements
      let version2 = try? OSVer(array: [majorVersion, minorVersion])
      XCTAssertNotNil(version2)
      XCTAssertEqual(version2?.majorVersion, majorVersion)
      XCTAssertEqual(version2?.minorVersion, minorVersion)
      XCTAssertEqual(version2?.patchVersion, 0)
    }
  }

  // MARK: - Fuzzy String Tests

  func testFuzzyStringParsing() {
    for _ in 0..<1000 {
      let majorVersion = Int.random(in: 0...100)
      let minorVersion = Int.random(in: 0...100)
      let patchVersion = Int.random(in: 0...100)

      // Test with patch version
      let versionString1 = "\(majorVersion).\(minorVersion).\(patchVersion)"
      let version1 = try? OSVer(string: versionString1)
      XCTAssertNotNil(version1)
      XCTAssertEqual(version1?.majorVersion, majorVersion)
      XCTAssertEqual(version1?.minorVersion, minorVersion)
      XCTAssertEqual(version1?.patchVersion, patchVersion)

      // Test without patch version
      let versionString2 = "\(majorVersion).\(minorVersion)"
      let version2 = try? OSVer(string: versionString2)
      XCTAssertNotNil(version2)
      XCTAssertEqual(version2?.majorVersion, majorVersion)
      XCTAssertEqual(version2?.minorVersion, minorVersion)
      XCTAssertEqual(version2?.patchVersion, 0)
    }
  }

  // MARK: - Fuzzy Codable Tests

  func testFuzzyCodable() {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    for _ in 0..<1000 {
      let majorVersion = Int.random(in: 0...100)
      let minorVersion = Int.random(in: 0...100)
      let patchVersion = Int.random(in: 0...100)

      let original = OSVer(
        majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion)

      // Test object encoding/decoding
      do {
        encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.object
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(OSVer.self, from: data)
        XCTAssertEqual(original, decoded)
      } catch {
        XCTFail("Failed to encode/decode as object: \(error)")
      }

      // Test string encoding/decoding
      do {
        encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.string
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(OSVer.self, from: data)
        XCTAssertEqual(original, decoded)
      } catch {
        XCTFail("Failed to encode/decode as string: \(error)")
      }

      // Test array encoding/decoding
      do {
        encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.array
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(OSVer.self, from: data)
        XCTAssertEqual(original, decoded)
      } catch {
        XCTFail("Failed to encode/decode as array: \(error)")
      }
    }
  }

  // MARK: - Edge Case Tests

  func testEdgeCases() {
    let edgeCaseValues = [Int.min, Int.max, 0, -1, 1]

    for majorVersion in edgeCaseValues {
      for minorVersion in edgeCaseValues {
        for patchVersion in edgeCaseValues {
          // Test initialization
          let version = OSVer(
            majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion)
          XCTAssertEqual(version.majorVersion, majorVersion)
          XCTAssertEqual(version.minorVersion, minorVersion)
          XCTAssertEqual(version.patchVersion, patchVersion)

          // Test array initialization
          let arrayVersion = try? OSVer(array: [majorVersion, minorVersion, patchVersion])
          XCTAssertNotNil(arrayVersion)
          XCTAssertEqual(arrayVersion?.majorVersion, majorVersion)
          XCTAssertEqual(arrayVersion?.minorVersion, minorVersion)
          XCTAssertEqual(arrayVersion?.patchVersion, patchVersion)

          // Test string parsing
          let stringVersion = try? OSVer(string: "\(majorVersion).\(minorVersion).\(patchVersion)")
          XCTAssertNotNil(stringVersion)
          XCTAssertEqual(stringVersion?.majorVersion, majorVersion)
          XCTAssertEqual(stringVersion?.minorVersion, minorVersion)
          XCTAssertEqual(stringVersion?.patchVersion, patchVersion)

          // Test Codable
          let encoder = JSONEncoder()
          encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.object

          do {
            let data = try encoder.encode(version)
            let decoded = try JSONDecoder().decode(OSVer.self, from: data)
            XCTAssertEqual(version, decoded)
          } catch {
            XCTFail(
              "Failed to encode/decode edge case: \(majorVersion).\(minorVersion).\(patchVersion)")
          }
        }
      }
    }
  }

  // MARK: - Comparison Transitivity Tests

  func testComparisonTransitivity() {
    for _ in 0..<1000 {
      let v1 = OSVer(
        majorVersion: Int.random(in: 0...5),
        minorVersion: Int.random(in: 0...5),
        patchVersion: Int.random(in: 0...5)
      )
      let v2 = OSVer(
        majorVersion: Int.random(in: 0...5),
        minorVersion: Int.random(in: 0...5),
        patchVersion: Int.random(in: 0...5)
      )
      let v3 = OSVer(
        majorVersion: Int.random(in: 0...5),
        minorVersion: Int.random(in: 0...5),
        patchVersion: Int.random(in: 0...5)
      )

      // Test transitivity
      if v1 < v2 && v2 < v3 {
        XCTAssertLessThan(v1, v3)
      }

      if v1 > v2 && v2 > v3 {
        XCTAssertGreaterThan(v1, v3)
      }

      if v1 == v2 && v2 == v3 {
        XCTAssertEqual(v1, v3)
      }
    }
  }
}
