# OSVer

[![](https://img.shields.io/badge/docc-read_documentation-blue)](https://swiftpackageindex.com/brightdigit/OSVer/documentation)
[![SwiftPM](https://img.shields.io/badge/SPM-Linux%20%7C%20iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-success?logo=swift)](https://swift.org)
[![Twitter](https://img.shields.io/badge/twitter-@brightdigit-blue.svg?style=flat)](http://twitter.com/brightdigit)
![GitHub](https://img.shields.io/github/license/brightdigit/OSVer)
![GitHub issues](https://img.shields.io/github/issues/brightdigit/OSVer)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/brightdigit/OSVer/OSVer.yml?label=actions&logo=github&?branch=main)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FOSVer%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/brightdigit/OSVer)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FOSVer%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/brightdigit/OSVer)

[![Codecov](https://img.shields.io/codecov/c/github/brightdigit/OSVer)](https://codecov.io/gh/brightdigit/OSVer)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/brightdigit/OSVer)](https://www.codefactor.io/repository/github/brightdigit/OSVer)
[![codebeat badge](https://codebeat.co/badges/39ec3212-10bf-4f4a-91fc-3a842d506c64)](https://codebeat.co/projects/github-com-brightdigit-OSVer-main)
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/brightdigit/OSVer)](https://codeclimate.com/github/brightdigit/OSVer)
[![Code Climate technical debt](https://img.shields.io/codeclimate/tech-debt/brightdigit/OSVer?label=debt)](https://codeclimate.com/github/brightdigit/OSVer)
[![Code Climate issues](https://img.shields.io/codeclimate/issues/brightdigit/OSVer)](https://codeclimate.com/github/brightdigit/OSVer)

A Swift package that provides a lightweight, safe wrapper around `Foundation.OperatingSystemVersion` with additional features like JSON encoding/decoding and string parsing.

## Features

- ✨ Codable support with flexible encoding formats (string or object)
- 🔒 Type-safe initialization and comparison
- 📝 String parsing and formatting
- 🎯 Swift Package Manager support
- 💪 Fully tested with unit and fuzzy tests

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/brightdigit/OSVer.git", from: "1.0.0")
]
```

## Usage

### Basic Initialization

```swift
// Initialize with major and minor versions (patch defaults to 0)
let version1 = OSVer(major: 1, minor: 2)

// Initialize with all components
let version2 = OSVer(major: 1, minor: 2, patch: 3)

// Initialize using OperatingSystemVersion style
let version3 = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)

// Initialize from OperatingSystemVersion
let osVersion = OperatingSystemVersion(majorVersion: 1, minorVersion: 2, patchVersion: 3)
let version4 = OSVer(osVersion)
```

### String Parsing

```swift
// Parse from string
let version = try OSVer(string: "1.2.3")

// Parse without patch version (defaults to 0)
let version = try OSVer(string: "1.2") // equivalent to "1.2.0"
```

### JSON Encoding/Decoding

```swift
// Encode as object (default)
let encoder = JSONEncoder()
let data = try encoder.encode(version)
// Result: {"major":1,"minor":2,"patch":3}

// Encode as string
encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.string
let stringData = try encoder.encode(version)
// Result: "1.2.3"

// Decode from either format
let decoder = JSONDecoder()
let version = try decoder.decode(OSVer.self, from: jsonData)
```

### Comparison

```swift
let v1 = OSVer(major: 1, minor: 2)
let v2 = OSVer(major: 1, minor: 3)

// Compare versions
if v1 < v2 {
    print("Version 1 is older")
}

// Use in collections
let versions: Set<OSVer> = [v1, v2]
let versionMap: [OSVer: String] = [
    v1: "Initial Release",
    v2: "Feature Update"
]
```

## Requirements

- Swift 5.9+
- iOS 17.0+ / macOS 14.0+ / tvOS 17.0+ / watchOS 10.0+

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
