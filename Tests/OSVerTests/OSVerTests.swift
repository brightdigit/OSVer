import XCTest
@testable import OSVer // Replace with your actual module name

final class OSVerTests: XCTestCase {
    // MARK: - Initialization Tests
    
    func testInitWithMajorMinor() {
        let version = OSVer(major: 1, minor: 2)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 0) // Default value
    }
    
    func testInitWithMajorMinorPatch() {
        let version = OSVer(major: 1, minor: 2, patch: 3)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
    }
    
    func testInitWithVersionStyle() {
        let version = OSVer(majorVersion: 1, minorVersion: 2, patchVersion: 3)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
    }
    
    func testInitWithOperatingSystemVersion() {
        let osVersion = OperatingSystemVersion(majorVersion: 1, minorVersion: 2, patchVersion: 3)
        let version = OSVer(osVersion)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
    }
    
    // MARK: - String Parsing Tests
    
    func testInitWithValidString() throws {
        let version = try OSVer(string: "1.2.3")
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
    }
    
    func testInitWithValidStringNoPatch() throws {
        let version = try OSVer(string: "1.2")
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 0)
    }
    
    func testInitWithInvalidFormatThrows() {
        XCTAssertThrowsError(try OSVer(string: "1")) { error in
            XCTAssertTrue(error is OSVer.ParsingError)
            XCTAssertEqual(error as? OSVer.ParsingError, .invalidFormat)
        }
    }
    
    func testInitWithInvalidNumbersThrows() {
        XCTAssertThrowsError(try OSVer(string: "1.x.3")) { error in
            XCTAssertTrue(error is OSVer.ParsingError)
            XCTAssertEqual(error as? OSVer.ParsingError, .invalidNumbers)
        }
    }
    
    // MARK: - Codable Tests
    
    func testEncodingAsObject() throws {
        let version = OSVer(major: 1, minor: 2, patch: 3)
        let encoder = JSONEncoder()
        encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.object
        
        let data = try encoder.encode(version)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Int]
        
        XCTAssertEqual(json["major"], 1)
        XCTAssertEqual(json["minor"], 2)
        XCTAssertEqual(json["patch"], 3)
    }
    
    func testEncodingAsString() throws {
        let version = OSVer(major: 1, minor: 2, patch: 3)
        let encoder = JSONEncoder()
        encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.string
        
        let data = try encoder.encode(version)
        let string = String(data: data, encoding: .utf8)!.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        
        XCTAssertEqual(string, "1.2.3")
    }
    
    func testDecodingFromObject() throws {
        let json = """
        {
            "major": 1,
            "minor": 2,
            "patch": 3
        }
        """.data(using: .utf8)!
        
        let version = try JSONDecoder().decode(OSVer.self, from: json)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
    }
    
    func testDecodingFromObjectWithoutPatch() throws {
        let json = """
        {
            "major": 1,
            "minor": 2
        }
        """.data(using: .utf8)!
        
        let version = try JSONDecoder().decode(OSVer.self, from: json)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 0)
    }
    
    func testDecodingFromString() throws {
        let json = "\"1.2.3\"".data(using: .utf8)!
        
        let version = try JSONDecoder().decode(OSVer.self, from: json)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
    }
    
    func testDecodingFromStringWithoutPatch() throws {
        let json = "\"1.2\"".data(using: .utf8)!
        
        let version = try JSONDecoder().decode(OSVer.self, from: json)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 0)
    }
    
    // MARK: - Equatable Tests
    
    func testEquality() {
        let version1 = OSVer(major: 1, minor: 2, patch: 3)
        let version2 = OSVer(major: 1, minor: 2, patch: 3)
        let version3 = OSVer(major: 1, minor: 2, patch: 4)
        
        XCTAssertEqual(version1, version2)
        XCTAssertNotEqual(version1, version3)
    }
    
    // MARK: - Hashable Tests
    
    func testHashable() {
        let version1 = OSVer(major: 1, minor: 2, patch: 3)
        let version2 = OSVer(major: 1, minor: 2, patch: 3)
        let version3 = OSVer(major: 1, minor: 2, patch: 4)
        
        var set = Set<OSVer>()
        set.insert(version1)
        set.insert(version2) // Should not increase size
        set.insert(version3)
        
        XCTAssertEqual(set.count, 2)
    }
    
    func testHashConsistency() {
        let version1 = OSVer(major: 1, minor: 2, patch: 3)
        let version2 = OSVer(major: 1, minor: 2, patch: 3)
        
        XCTAssertEqual(version1.hashValue, version2.hashValue)
    }
    
    // MARK: - Comparable Tests
    
    func testComparable() {
        let version1 = OSVer(major: 1, minor: 2, patch: 3)
        let version2 = OSVer(major: 1, minor: 2, patch: 4)
        let version3 = OSVer(major: 1, minor: 3, patch: 0)
        let version4 = OSVer(major: 2, minor: 0, patch: 0)
        
        XCTAssertLessThan(version1, version2)
        XCTAssertLessThan(version2, version3)
        XCTAssertLessThan(version3, version4)
        
        // Test greater than
        XCTAssertGreaterThan(version4, version3)
        XCTAssertGreaterThan(version3, version2)
        XCTAssertGreaterThan(version2, version1)
    }
    
    func testComparableDefaultPatch() {
        let version1 = OSVer(major: 1, minor: 2)
        let version2 = OSVer(major: 1, minor: 2, patch: 0)
        let version3 = OSVer(major: 1, minor: 2, patch: 1)
        
        XCTAssertEqual(version1, version2)
        XCTAssertLessThan(version1, version3)
    }
    
    // MARK: - Description Tests
    
    func testDescription() {
        let version = OSVer(major: 1, minor: 2, patch: 3)
        XCTAssertEqual(version.description, "1.2.3")
        
        let versionNoPatch = OSVer(major: 1, minor: 2)
        XCTAssertEqual(versionNoPatch.description, "1.2.0")
    }
}