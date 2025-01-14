//
//  OSVer.swift
//  OSVer
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

public struct OSVer: Hashable, Codable, Sendable {
  private enum CodingKeys: String, CodingKey {
    case major
    case minor
    case patch
  }

  // MARK: - Encoding Configuration

  public enum EncodingFormat: String, Codable {
    case string
    case object
  }

  public enum ParsingError: Error {
    case invalidFormat
    case invalidNumbers
  }

  // swiftlint:disable:next force_unwrapping line_length
  public static let encodingFormatKey = CodingUserInfoKey(rawValue: "osver.encodingFormat")!

  private let version: OperatingSystemVersion

  public var major: Int { version.majorVersion }
  public var minor: Int { version.minorVersion }
  public var patch: Int { version.patchVersion }

  public init(major: Int, minor: Int, patch: Int = 0) {
    version = OperatingSystemVersion(
      majorVersion: major,
      minorVersion: minor,
      patchVersion: patch
    )
  }

  public init(majorVersion: Int, minorVersion: Int, patchVersion: Int = 0) {
    version = OperatingSystemVersion(
      majorVersion: majorVersion,
      minorVersion: minorVersion,
      patchVersion: patchVersion
    )
  }

  public init(_ version: OperatingSystemVersion) {
    self.version = version
  }

  public init(string: String) throws {
    let numbers = string.split(separator: ".")
    guard numbers.count >= 2 else {
      throw ParsingError.invalidFormat
    }

    guard
      let major = Int(numbers[0]),
      let minor = Int(numbers[1])
    else {
      throw ParsingError.invalidNumbers
    }

    let patch = numbers.count > 2 ? Int(numbers[2]) ?? 0 : 0

    version = OperatingSystemVersion(
      majorVersion: major,
      minorVersion: minor,
      patchVersion: patch
    )
  }

  // MARK: - Codable

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    // Try to decode as string first
    if let versionString = try? container.decode(String.self) {
      do {
        let version = try OSVer(string: versionString)
        self = version
        return
      } catch {
        throw DecodingError.dataCorrupted(
          .init(
            codingPath: decoder.codingPath,
            debugDescription: "Invalid version string format: \(error)"
          )
        )
      }
    }

    // If string decoding fails, try object format
    let objectContainer = try decoder.container(keyedBy: CodingKeys.self)
    let major = try objectContainer.decode(Int.self, forKey: .major)
    let minor = try objectContainer.decode(Int.self, forKey: .minor)
    let patch = try objectContainer.decodeIfPresent(Int.self, forKey: .patch) ?? 0

    version = OperatingSystemVersion(
      majorVersion: major,
      minorVersion: minor,
      patchVersion: patch
    )
  }

  public func encode(to encoder: Encoder) throws {
    // Check encoding format and default to object if not specified
    let format = encoder.userInfo[OSVer.encodingFormatKey] as? EncodingFormat ?? .object
    if format == .string {
      var container = encoder.singleValueContainer()
      try container.encode(description)
    } else {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(major, forKey: .major)
      try container.encode(minor, forKey: .minor)
      try container.encode(patch, forKey: .patch)
    }
  }
}

extension OSVer {
  public static func == (lhs: OSVer, rhs: OSVer) -> Bool {
    lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(major)
    hasher.combine(minor)
    hasher.combine(patch)
  }
}
