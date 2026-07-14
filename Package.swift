// swift-tools-version: 6.1

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InternalImportsByDefault")
]

let package = Package(
    name: "AzooKeyKanaKanjiConverter",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "KanaKanjiConverterModuleWithDefaultDictionary",
            targets: ["KanaKanjiConverterModuleWithDefaultDictionary"]
        )
    ],
    dependencies: [
        // Keep Keebo's audited v0.11.2 dependency graph reproducible.
        .package(url: "https://github.com/apple/swift-algorithms", exact: "1.2.1"),
        .package(url: "https://github.com/apple/swift-collections", exact: "1.5.0")
    ],
    targets: [
        .target(
            name: "SwiftUtils",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "KanaKanjiConverterModule",
            dependencies: [
                "SwiftUtils",
                .product(name: "Collections", package: "swift-collections")
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "KanaKanjiConverterModuleWithDefaultDictionary",
            dependencies: [
                "KanaKanjiConverterModule"
            ],
            exclude: [
                "azooKey_dictionary_storage/README.md",
                "azooKey_dictionary_storage/LICENSE",
                "azooKey_emoji_dictionary_storage/data",
                "azooKey_emoji_dictionary_storage/scripts",
                "azooKey_emoji_dictionary_storage/requirements.txt",
                "azooKey_emoji_dictionary_storage/README.md"
            ],
            resources: [
                .copy("azooKey_dictionary_storage/Dictionary"),
                .copy("azooKey_emoji_dictionary_storage/EmojiDictionary")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SwiftUtilsTests",
            dependencies: ["SwiftUtils"],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "KanaKanjiConverterModuleTests",
            dependencies: ["KanaKanjiConverterModule"],
            resources: [
                .copy("DictionaryMock")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "KanaKanjiConverterModuleWithDefaultDictionaryTests",
            dependencies: [
                "KanaKanjiConverterModuleWithDefaultDictionary",
                .product(name: "Collections", package: "swift-collections")
            ],
            swiftSettings: swiftSettings
        )
    ]
)
