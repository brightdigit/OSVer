import Foundation

public struct OSVer: Hashable, Codable, Sendable {
    private let version: OperatingSystemVersion
    
    public var major: Int { version.majorVersion }
    public var minor: Int { version.minorVersion }
    public var patch: Int { version.patchVersion }
    
    // MARK: - Encoding Configuration
    
    public enum EncodingFormat: String, Codable {
        case string
        case object
    }
    
    public static let encodingFormatKey = CodingUserInfoKey(rawValue: "osver.encodingFormat")!
    
    public init(major: Int, minor: Int, patch: Int = 0) {
        self.version = OperatingSystemVersion(majorVersion: major, minorVersion: minor, patchVersion: patch)
    }
    
    public init(majorVersion: Int, minorVersion: Int, patchVersion: Int = 0) {
        self.version = OperatingSystemVersion(majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion)
    }
    
    public init(_ version: OperatingSystemVersion) {
        self.version = version
    }
    
    // MARK: - String Parsing
    
    public enum ParsingError: Error {
        case invalidFormat
        case invalidNumbers
    }
    
  public init(string: String) throws (ParsingError) {
        let numbers = string.split(separator: ".")
        guard numbers.count >= 2 else {
            throw ParsingError.invalidFormat
        }
        
        guard let major = Int(numbers[0]),
              let minor = Int(numbers[1]) else {
            throw ParsingError.invalidNumbers
        }
        
        let patch = numbers.count > 2 ? Int(numbers[2]) ?? 0 : 0
        
        self.version = OperatingSystemVersion(majorVersion: major, minorVersion: minor, patchVersion: patch)
    }
    
    // MARK: - Codable
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try to decode as string first
        if let versionString = try? container.decode(String.self) {
            do {
                let version = try OSVer(string: versionString)
                self = version
                return
            } catch {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                                                      debugDescription: "Invalid version string format: \(error)"))
            }
        }
        
        // If string decoding fails, try object format
        let objectContainer = try decoder.container(keyedBy: CodingKeys.self)
        let major = try objectContainer.decode(Int.self, forKey: .major)
        let minor = try objectContainer.decode(Int.self, forKey: .minor)
        let patch = try objectContainer.decodeIfPresent(Int.self, forKey: .patch) ?? 0
        
        self.version = OperatingSystemVersion(majorVersion: major, minorVersion: minor, patchVersion: patch)
    }
    
    public func encode(to encoder: Encoder) throws {
        // Check encoding format and default to object if not specified
        let format = encoder.userInfo[OSVer.encodingFormatKey] as? EncodingFormat ?? .object
        if format == .string {
            var container = encoder.singleValueContainer()
            try container.encode(description)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(major, forKey: .major)
            try container.encode(minor, forKey: .minor)
            try container.encode(patch, forKey: .patch)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case major
        case minor
        case patch
    }
}

extension OSVer {
    public static func == (lhs: OSVer, rhs: OSVer) -> Bool {
        lhs.major == rhs.major &&
        lhs.minor == rhs.minor &&
        lhs.patch == rhs.patch
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(major)
        hasher.combine(minor)
        hasher.combine(patch)
    }
}
