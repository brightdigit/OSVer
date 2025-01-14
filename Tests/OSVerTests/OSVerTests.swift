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
    
    // MARK: - Fuzzy Tests
    
    func testFuzzyInitialization() {
        for _ in 0..<1000 {
            let major = Int.random(in: 0...100)
            let minor = Int.random(in: 0...100)
            let patch = Int.random(in: 0...100)
            
            let version = OSVer(major: major, minor: minor, patch: patch)
            XCTAssertEqual(version.major, major)
            XCTAssertEqual(version.minor, minor)
            XCTAssertEqual(version.patch, patch)
        }
    }
    
    func testFuzzyComparison() {
        for _ in 0..<1000 {
            let major1 = Int.random(in: 0...10)
            let minor1 = Int.random(in: 0...10)
            let patch1 = Int.random(in: 0...10)
            
            let major2 = Int.random(in: 0...10)
            let minor2 = Int.random(in: 0...10)
            let patch2 = Int.random(in: 0...10)
            
            let version1 = OSVer(major: major1, minor: minor1, patch: patch1)
            let version2 = OSVer(major: major2, minor: minor2, patch: patch2)
            
            // Test transitivity
            if version1 < version2 {
                XCTAssertFalse(version2 < version1)
                XCTAssertFalse(version1 == version2)
            } else if version2 < version1 {
                XCTAssertFalse(version1 < version2)
                XCTAssertFalse(version1 == version2)
            } else {
                XCTAssertEqual(version1, version2)
            }
        }
    }
    
    func testFuzzyCodable() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        for _ in 0..<1000 {
            let major = Int.random(in: 0...100)
            let minor = Int.random(in: 0...100)
            let patch = Int.random(in: 0...100)
            
            let original = OSVer(major: major, minor: minor, patch: patch)
            
            // Test object encoding/decoding
            do {
                encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.object
                let data = try encoder.encode(original)
                let decoded = try decoder.decode(OSVer.self, from: data)
                XCTAssertEqual(original, decoded)
            } catch {
                XCTFail("Failed to encode/decode as object: \(error)")
            }
            
            // Test string encoding/decoding
            do {
                encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.string
                let data = try encoder.encode(original)
                let decoded = try decoder.decode(OSVer.self, from: data)
                XCTAssertEqual(original, decoded)
            } catch {
                XCTFail("Failed to encode/decode as string: \(error)")
            }
        }
    }
    
    func testFuzzyStringParsing() {
        for _ in 0..<1000 {
            let major = Int.random(in: 0...100)
            let minor = Int.random(in: 0...100)
            let patch = Int.random(in: 0...100)
            
            let versionString = "\(major).\(minor).\(patch)"
            
            do {
                let version = try OSVer(string: versionString)
                XCTAssertEqual(version.major, major)
                XCTAssertEqual(version.minor, minor)
                XCTAssertEqual(version.patch, patch)
            } catch {
                XCTFail("Failed to parse valid version string: \(versionString)")
            }
        }
    }
    
    func testFuzzyHashable() {
        var versions = Set<OSVer>()
        var originalCount = 0
        
        for _ in 0..<1000 {
            let major = Int.random(in: 0...10)
            let minor = Int.random(in: 0...10)
            let patch = Int.random(in: 0...10)
            
            let version = OSVer(major: major, minor: minor, patch: patch)
            let (inserted, _) = versions.insert(version)
            if inserted {
                originalCount += 1
            }
            
            // Test that identical versions have same hash
            let duplicate = OSVer(major: major, minor: minor, patch: patch)
            versions.insert(duplicate)
            XCTAssertEqual(versions.count, originalCount)
        }
    }
    
    func testFuzzyEdgeCases() {
        let edgeCaseValues = [Int.min, Int.max, 0, -1, 1]
        
        for major in edgeCaseValues {
            for minor in edgeCaseValues {
                for patch in edgeCaseValues {
                    let version = OSVer(major: major, minor: minor, patch: patch)
                    XCTAssertEqual(version.major, major)
                    XCTAssertEqual(version.minor, minor)
                    XCTAssertEqual(version.patch, patch)
                    
                    // Test serialization
                    let encoder = JSONEncoder()
                    encoder.userInfo[OSVer.encodingFormatKey] = OSVer.EncodingFormat.object
                    
                    do {
                        let data = try encoder.encode(version)
                        let decoded = try JSONDecoder().decode(OSVer.self, from: data)
                        XCTAssertEqual(version, decoded)
                    } catch {
                        XCTFail("Failed to encode/decode edge case: \(major).\(minor).\(patch)")
                    }
                }
            }
        }
    }
}