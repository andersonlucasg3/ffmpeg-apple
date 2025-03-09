// swift-tools-version: 6.0

import PackageDescription
import Foundation

func enumerateFiles(at path: String, _ block: (String)->Void)
{
    let fileManager = FileManager.default
    let enumerator = fileManager.enumerator(atPath: path)
    while let element = enumerator?.nextObject() as? String
    {
        block(element)
    }
}

func patternsToExclude(at path: String, _ patterns: [String]) -> [String]
{
    var excludes: [String] = []

    enumerateFiles(at: path) { file in
        for regex in patterns
        {
            if file.contains(regex)
            {
                excludes.append(file)
            }
        }
    }

    return excludes
}

let sourcesPath = (FileManager.default.currentDirectoryPath as NSString).appendingPathComponent("Sources")

let privatePath = (sourcesPath as NSString).appendingPathComponent("Private")

var excludes = patternsToExclude(at: privatePath, ["vulkan", "d3d"]).map { each in
    "Private/\(each)"
}

print("Excludes: \(excludes)")

let package = Package(
    name: "libavutil",
    products: [
        .library(
            name: "avutil",
            targets: ["avutil"]
        )
    ],
    targets: [
        .target(
            name: "avutil",
            exclude: excludes,
            sources: [
                "Private"
            ],
            publicHeadersPath: "Public"
        )
    ]
)
