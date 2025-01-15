//
//  OSVer+Init.swift
//  OSVer
//
//  Created by Leo Dion on 1/15/25.
//

import Foundation

extension OSVer {
  /// Initializes an `OSVer` instance
  /// with the given major, minor, and patch version numbers.
  /// - Parameters:
  ///   - majorVersion: The major version number.
  ///   - minorVersion: The minor version number.
  ///   - patchVersion: The patch version number (default is 0).
  public init(majorVersion: Int, minorVersion: Int, patchVersion: Int = 0) {
    self.init(
      OperatingSystemVersion(
        majorVersion: majorVersion,
        minorVersion: minorVersion,
        patchVersion: patchVersion
      )
    )
  }

  /// Initializes an `OSVer` instance
  /// from a version string in the format "major.minor.patch".
  /// - Parameter string: The version string to parse.
  public init(string: String) throws {
    try self.init(parsing: string)
  }

  /// Initializes an `OSVer` instance
  /// from a version string in the format "major.minor.patch".
  /// - Parameter array: The array to parse.
  /// - Throws: `ParsingError.invalidLength` if the array is not the correct length.
  public init(array: [Int]) throws {
    try self.init(parsing: array)
  }
}
