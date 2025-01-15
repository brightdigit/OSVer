//
//  OSVer+Hashable.swift
//  OSVer
//
//  Created by Leo Dion on 1/14/25.
//

extension OSVer {
  /// Tests the equality of two OSVer objects.
  /// - Parameters:
  ///   - lhs:an OSVer Object
  ///   - rhs:another OSVer Object
  /// - Returns: True, if equal
  public static func == (lhs: OSVer, rhs: OSVer) -> Bool {
    lhs.majorVersion == rhs.majorVersion && lhs.minorVersion == rhs.minorVersion
      && lhs.patchVersion == rhs.patchVersion
  }

  /// Creates a hash from the OSVer,
  /// - Parameter hasher: The hasher.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(majorVersion)
    hasher.combine(minorVersion)
    hasher.combine(patchVersion)
  }
}
