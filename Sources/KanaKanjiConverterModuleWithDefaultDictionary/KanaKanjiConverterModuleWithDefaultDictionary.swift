import Foundation
@_exported public import KanaKanjiConverterModule

enum DefaultDictionaryResources {
    static var directoryURL: URL {
        #if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        Bundle.module.bundleURL.appendingPathComponent("Dictionary", isDirectory: true)
        #elseif os(macOS)
        Bundle.module.resourceURL!.appendingPathComponent("Dictionary", isDirectory: true)
        #else
        Bundle.module.resourceURL!.appendingPathComponent("Dictionary", isDirectory: true)
        #endif
    }

    static var containsEmojiDictionary: Bool {
        let roots = [Bundle.module.bundleURL, Bundle.module.resourceURL].compactMap { $0 }
        return roots.contains { root in
            FileManager.default.fileExists(
                atPath: root.appendingPathComponent("EmojiDictionary", isDirectory: true).path
            )
        }
    }
}

public extension DicdataStore {
    static func withDefaultDictionary(preloadDictionary: Bool = false) -> Self {
        .init(
            dictionaryURL: DefaultDictionaryResources.directoryURL,
            preloadDictionary: preloadDictionary
        )
    }
}

public extension KanaKanjiConverter {
    static func withDefaultDictionary(preloadDictionary: Bool = false) -> Self {
        .init(dicdataStore: .withDefaultDictionary(preloadDictionary: preloadDictionary))
    }
}

public extension TextReplacer {
    /// Compatibility shim for clients of the 8key fork. The optional upstream
    /// emoji data is no longer distributed by this product.
    @available(
        *,
        deprecated,
        message: "The default emoji dictionary is not bundled; use TextReplacer.empty."
    )
    static func withDefaultEmojiDictionary() -> Self {
        .empty
    }
}
