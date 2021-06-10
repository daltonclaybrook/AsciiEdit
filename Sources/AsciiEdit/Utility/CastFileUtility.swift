import Foundation

struct CastFileUtility {
    static func updateSize(of file: inout CastFile, width: Int?, height: Int?) {
        if let width = width {
            file.header.width = width
        }
        if let height = height {
            file.header.height = height
        }
    }

    static func constrainMaxDuration(of file: inout CastFile, maxDuration: TimeInterval?) {
        guard let maxDuration = maxDuration, file.entries.count > 1 else { return }

        for index in (0..<(file.entries.count - 1)) {
            let duration = file.entries[index + 1].startTime - file.entries[index].startTime
            guard duration > maxDuration else { continue }

            // calculate the difference to use for adjustments
            let nextStartTime = file.entries[index].startTime + maxDuration
            let difference = file.entries[index + 1].startTime - nextStartTime

            // adjust all following entries
            for nextIndex in ((index + 1)..<file.entries.count) {
                file.entries[nextIndex].startTime -= difference
            }
        }
    }
}
