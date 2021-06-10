extension AsciiEdit.Error: CustomStringConvertible {
    var description: String {
        switch self {
        case .inputFileDoesNotExist(let path):
            return "File does not exist at the provided path \(path)"
        }
    }
}

extension CastFile.Error: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidHeader(_):
            return "The provided cast file contains an invalid header"
        case .invalidEntry(_):
            return "The provided cast file contains an invalid entry"
        case .failedToEncodeHeader:
            return "Failed to encode the cast file header"
        case .failedToEncodeEntry:
            return "Failed to encode a cast file entry"
        }
    }
}
