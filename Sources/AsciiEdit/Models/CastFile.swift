import Foundation

struct CastFile {
    struct Header: Codable {
        var version: Int
        var width: Int
        var height: Int
        var timestamp: UInt64
        var env: [String: String]
    }

    struct Entry {
        /// The start time of the entry relative to the beginning of playback
        var startTime: TimeInterval
        /// The second element in the entry. I do not know its purpose. It normally has a value of "o".
        let fooBar: String
        /// The text of the entry
        var text: String
    }

    var header: Header
    var entries: [Entry]
}

extension CastFile.Entry: Codable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        startTime = try container.decode(TimeInterval.self)
        fooBar = try container.decode(String.self)
        text = try container.decode(String.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(startTime)
        try container.encode(fooBar)
        try container.encode(text)
    }
}

extension CastFile {
    enum Error: Swift.Error {
        case invalidHeader(String?)
        case invalidEntry(String)
        case failedToEncodeHeader
        case failedToEncodeEntry
    }

    init(fileText: String) throws {
        var lines = fileText.components(separatedBy: "\n")
        guard lines.count >= 1 else {
            throw Error.invalidHeader(nil)
        }

        let headerString = lines.removeFirst()
        guard let headerData = headerString.data(using: .utf8) else {
            throw Error.invalidHeader(headerString)
        }

        let decoder = JSONDecoder()
        self.header = try decoder.decode(Header.self, from: headerData)
        self.entries = try lines.compactMap { entryLine -> Entry? in
            guard !entryLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                // Return if this line is empty
                return nil
            }
            guard let entryData = entryLine.data(using: .utf8) else {
                throw Error.invalidEntry(entryLine)
            }
            return try decoder.decode(Entry.self, from: entryData)
        }
    }

    func generateFileText() throws -> String {
        let encoder = JSONEncoder()
        let headerData = try encoder.encode(header)
        guard let headerString = String(data: headerData, encoding: .utf8) else {
            throw Error.failedToEncodeHeader
        }

        let entryStrings = try entries.map { entry -> String in
            let entryData = try encoder.encode(entry)
            guard let entryString = String(data: entryData, encoding: .utf8) else {
                throw Error.failedToEncodeEntry
            }
            return entryString
        }

        return ([headerString] + entryStrings).joined(separator: "\n")
    }
}
