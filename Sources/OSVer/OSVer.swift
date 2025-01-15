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

/// Represents an operating system version.
public struct OSVer: Hashable, Codable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case majorVersion
    case minorVersion
    case patchVersion
  }

  // MARK: - Encoding Configuration

  /// Represents the encoding format for `OSVer` instances.
  public enum EncodingFormat: String, Codable {
    case string
    case object
    case array
  }

  /// Errors that can occur during parsing of an `OSVer` string.
  public enum ParsingError: Error {
    case invalidFormat
    case invalidNumbers
    case invalidArrayLength
  }

  // swiftlint:disable:next force_unwrapping line_length
  public static let encodingFormatKey = CodingUserInfoKey(rawValue: "osver.encodingFormat")!

  private let version: OperatingSystemVersion

  /// The major version number.
  public var majorVersion: Int { version.majorVersion }

  /// The minor version number.
  public var minorVersion: Int { version.minorVersion }

  /// The patch version number.
  public var patchVersion: Int { version.patchVersion }

  /// Initializes an `OSVer` instance
  /// from an `OperatingSystemVersion` instance.
  /// - Parameter version: The `OperatingSystemVersion` instance
  /// to initialize the `OSVer` instance with.
  public init(_ version: OperatingSystemVersion) {
    self.version = version
  }

  // MARK: - Codable

  private init(asObjectFrom decoder: any Decoder) throws {
    // If string decoding fails, try object format
    let objectContainer = try decoder.container(keyedBy: CodingKeys.self)
    let major = try objectContainer.decode(Int.self, forKey: .majorVersion)
    let minor = try objectContainer.decode(Int.self, forKey: .minorVersion)
    let patch = try objectContainer.decodeIfPresent(Int.self, forKey: .patchVersion) ?? 0

    version = OperatingSystemVersion(
      majorVersion: major,
      minorVersion: minor,
      patchVersion: patch
    )
  }

  private init<T: OSVerParseable>(
    decoding value: T,
    codingPath: [CodingKey]
  ) throws {
    do {
      self = try value.parseVersion()
    } catch {
      throw DecodingError.dataCorrupted(
        .init(
          codingPath: codingPath,
          debugDescription: "Invalid version format: \(error)"
        )
      )
    }
  }

  private init?(
    container: any SingleValueDecodingContainer,
    codingPath: [CodingKey]
  ) throws {
    if let value = try? container.decode(String.self) {
      try self.init(decoding: value, codingPath: codingPath)
    } else if let value = try? container.decode([Int].self) {
      try self.init(decoding: value, codingPath: codingPath)
    } else {
      return nil
    }
  }
  internal init<T: OSVerParseable>(parsing value: T) throws {
    self = try value.parseVersion()
  }

  private init?(fromSingleValueContainer decoder: any Decoder) throws {
    if let container = try? decoder.singleValueContainer() {
      try self.init(container: container, codingPath: decoder.codingPath)
    } else {
      return nil
    }
  }

  public init(from decoder: Decoder) throws {
    if let version = try OSVer(fromSingleValueContainer: decoder) {
      self = version
    } else {
      try self.init(asObjectFrom: decoder)
    }
  }

  public func encode(to encoder: Encoder) throws {
    // Check encoding format and default to object if not specified
    let format = encoder.userInfo[OSVer.encodingFormatKey] as? EncodingFormat ?? .object

    switch format {
    case .string:
      var container = encoder.singleValueContainer()
      try container.encode(description)

    case .array:
      var container = encoder.singleValueContainer()
      try container.encode([majorVersion, minorVersion, patchVersion])

    case .object:
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(majorVersion, forKey: .majorVersion)
      try container.encode(minorVersion, forKey: .minorVersion)
      try container.encode(patchVersion, forKey: .patchVersion)
    }
  }
}
