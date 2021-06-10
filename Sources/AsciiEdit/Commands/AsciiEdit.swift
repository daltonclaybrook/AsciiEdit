import ArgumentParser
import PathKit

final class AsciiEdit: ParsableCommand {
    enum Error: Swift.Error {
        case inputFileDoesNotExist
    }

    static let configuration = CommandConfiguration(
        abstract: "A utility for editing `cast` files produced with asciinema",
        version: "0.1.0"
    )

    @Argument(help: "Path to the cast file to edit")
    var file: String

    @Option(name: [.short, .long], help: "A new width to apply to the cast file")
    var width: Int?

    @Option(name: [.short, .long], help: "A new height to apply to the cast file")
    var height: Int?

    @Option(name: [.customShort("d"), .long], help: "A maximum duration in seconds used to clamp each item in the cast file.")
    var maxDuration: Double?

    @Option(name: [.short, .long], help: "Where the output cast file should be saved. The default is to overwrite the input file.")
    var output: String?

    func run() throws {
        let inputPath = Path(file)
        guard inputPath.exists else {
            throw Error.inputFileDoesNotExist
        }

        var castFile = try CastFile(fileText: inputPath.read())
        CastFileUtility.updateSize(of: &castFile, width: width, height: height)
        CastFileUtility.constrainMaxDuration(of: &castFile, maxDuration: maxDuration)
        let outputText = try castFile.generateFileText()
        let outputFilePath = output.map { Path($0) } ?? inputPath
        try outputFilePath.write(outputText)

        print("✅  Done!")
    }
}
