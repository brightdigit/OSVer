import Testing
import Foundation
@testable import OSVer // Replace with your actual module name

@Suite("OSVer Tests")
struct OSVerTests {
    // MARK: - Initialization Tests
    
    @Test("Initializes with major and minor")
    func initWithMajorMinor() {
        let version = OSVer(major: 1, minor: 2)
        #expect(version.major == 1)
        #expect(version.minor == 2)
        #expect(version.patch == 0) // Default value
    }
    
    @Test("Initializes with major, minor, and patch")
    func initWithMajorMinorPatch() {
        let version = OSVer(major: 1, minor: 2, patch: 3)
        #expect(version.major == 1)
        #expect(version.minor == 2)
        #expect(version.patch == 3)
    }
    
    @Test("Initializes with version style parameters")
    func initWithVersionStyle() {
        let version = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
        #expect(version.major == 1)
        #expect(version.minor == 2)
        #expect(version.patch == 3)
    }
    
    @Test("Initializes from OperatingSystemVersion")
    func initWithOperatingSystemVersion() {
        let osVersion = OperatingSystemVersion(majorVersion: 1, minorVersion: 2, patchVersion: 3)
        let version = OSVer(osVersion)
        #expect(version.major == 1)
        #expect(version.minor == 2)
        #expect(version.patch == 3)
    }
    
    // MARK: - String Parsing Tests
    
    @Test("Parses valid version string with patch")
    func initWithValidString() throws {
        let version = try OSVer(string: "1.2.3")
        #expect(version.major == 1)
        #expect(version.minor == 2)
        #expect(version.patch == 3)
    }
    
    @Test("Parses valid version string without patch")
    func initWithValidStringNoPatch() throws {
        let version = try OSVer(string: "1.2")
        #expect(version.major == 1)
        #expect(version.minor == 2)
        #expect(version.patch == 0)
    }
    
    @Test("Throws on invalid format")
    func initWithInvalidFormat() throws {
        #expect(throws: OSVer.ParsingError.invalidFormat) {
            try OSVer(string: "1")
        }
    }
    
    @Test("Throws on invalid numbers")
    func initWithInvalidNumbers() async throws {
        #expect(throws: OSVer.ParsingError.invalidNumbers) {
            try OSVer(string: "1.x.3")
        }
    }
    
    // MARK: - Codable Tests
    
    @Test("Encodes as object")
    func encodingAsObject() throws {
        let version = OSVer(major: 1, minor: 2, patch: 3)
        let encoder = JSONEncoder()
        encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.object
        
        let data = try encoder.encode(version)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Int]
        
        #expect(json["major"] == 1)
        #expect(json["minor"] == 2)
        #expect(json["patch"] == 3)
    }
    
    @Test("Encodes as string")
    func encodingAsString() throws {
        let version = OSVer(major: 1, minor: 2, patch: 3)
        let encoder = JSONEncoder()
        encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.string
        
        let data = try encoder.encode(version)
        let string = String(data: data, encoding: .utf8)!.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        
        #expect(string == "1.2.3")
    }
    
    @Test("Decodes from object")
    func decodingFromObject() throws {
        let json = """
        {
            "major": 1,
            "minor": 2,
            "patch": 3
        }
        """.data(using: .utf8)!
        
        let version = try JSONDecoder().decode(OSVer.self, from: json)
        #expect(version.major == 1)
        #expect(version.minor == 2)
        #expect(version.patch == 3)
    }
    
    @Test("Decodes from string")
    func decodingFromString() throws {
        let json = "\"1.2.3\"".data(using: .utf8)!
        
        let version = try JSONDecoder().decode(OSVer.self, from: json)
        #expect(version.major == 1)
        #expect(version.minor == 2)
        #expect(version.patch == 3)
    }
    
    // MARK: - Equatable Tests
    
    @Test("Implements equality correctly")
    func equality() {
        let version1 = OSVer(major: 1, minor: 2, patch: 3)
        let version2 = OSVer(major: 1, minor: 2, patch: 3)
        let version3 = OSVer(major: 1, minor: 2, patch: 4)
        
        #expect(version1 == version2)
        #expect(version1 != version3)
    }
    
    // MARK: - Hashable Tests
    
    @Test("Works correctly in Set")
    func hashableInSet() {
        let version1 = OSVer(major: 1, minor: 2, patch: 3)
        let version2 = OSVer(major: 1, minor: 2, patch: 3)
        let version3 = OSVer(major: 1, minor: 2, patch: 4)
        
        var set = Set<OSVer>()
        set.insert(version1)
        set.insert(version2) // Should not increase size
        set.insert(version3)
        
        #expect(set.count == 2)
    }
    
    // MARK: - Comparable Tests
    
    @Test("Implements comparison correctly")
    func comparable() {
        let version1 = OSVer(major: 1, minor: 2, patch: 3)
        let version2 = OSVer(major: 1, minor: 2, patch: 4)
        let version3 = OSVer(major: 1, minor: 3, patch: 0)
        let version4 = OSVer(major: 2, minor: 0, patch: 0)
        
        #expect(version1 < version2)
        #expect(version2 < version3)
        #expect(version3 < version4)
        
        #expect(version4 > version3)
        #expect(version3 > version2)
        #expect(version2 > version1)
    }
    
    // MARK: - Description Tests
    
    @Test("Formats description correctly")
    func description() {
        let version = OSVer(major: 1, minor: 2, patch: 3)
        #expect(version.description == "1.2.3")
        
        let versionNoPatch = OSVer(major: 1, minor: 2)
        #expect(versionNoPatch.description == "1.2.0")
    }
}
