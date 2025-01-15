//
//  OSVer+Comparable.swift
//  OSVer
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

/// Extends the `OSVer` type to conform to the `Comparable` protocol.
extension OSVer: Comparable {
  /// Compares two `OSVer` instances and
  /// returns a boolean indicating if the left-hand side is less than the right-hand side.
  ///
  /// - Parameters:
  ///   - lhs: The left-hand side `OSVer` instance.
  ///   - rhs: The right-hand side `OSVer` instance.
  /// - Returns: `true` if the left-hand side is less than the right-hand side,
  /// `false` otherwise.
  public static func < (lhs: OSVer, rhs: OSVer) -> Bool {
    if lhs.majorVersion != rhs.majorVersion {
      return lhs.majorVersion < rhs.majorVersion
    }
    if lhs.minorVersion != rhs.minorVersion {
      return lhs.minorVersion < rhs.minorVersion
    }
    return lhs.patchVersion < rhs.patchVersion
  }
}
