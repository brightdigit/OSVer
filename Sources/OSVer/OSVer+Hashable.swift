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
    lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
  }

  /// Creates a hash from the OSVer,
  /// - Parameter hasher: The hasher.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(major)
    hasher.combine(minor)
    hasher.combine(patch)
  }
}
