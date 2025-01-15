//
//  OSVerParseable.swift
//  OSVer
//
//  Created by Leo Dion on 1/15/25.
//

internal protocol OSVerParseable {
  /// Attempts to create an `OSVer` from this type.
  /// - Throws: `OSVer.ParsingError` if the conversion fails.
  func parseVersion() throws -> OSVer
}

extension String: OSVerParseable {
  internal func parseVersion() throws -> OSVer {
    let components = self.split(separator: ".")
      .map(String.init)
    let componentIntegers: [Int] =
      components
      .compactMap(Int.init)

    guard components.count == componentIntegers.count else {
      throw OSVer.ParsingError.invalidFormat
    }

    return try OSVer(array: componentIntegers)
  }
}

extension Array: OSVerParseable where Element == Int {
  internal func parseVersion() throws -> OSVer {
    guard self.count >= 2 && self.count <= 3 else {
      throw OSVer.ParsingError.invalidArrayLength
    }

    return .init(
      majorVersion: self[0],
      minorVersion: self[1],
      patchVersion: self.count > 2 ? self[2] : 0
    )
  }
}
