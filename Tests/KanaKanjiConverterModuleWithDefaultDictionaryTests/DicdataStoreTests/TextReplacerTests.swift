@testable import KanaKanjiConverterModule
@testable import KanaKanjiConverterModuleWithDefaultDictionary
import XCTest

final class DefaultDictionaryResourceTests: XCTestCase {
    func testProductDoesNotBundleEmojiDictionary() {
        XCTAssertFalse(DefaultDictionaryResources.containsEmojiDictionary)
        XCTAssertTrue(
            FileManager.default.fileExists(
                atPath: DefaultDictionaryResources.directoryURL
                    .appendingPathComponent("mm.binary", isDirectory: false)
                    .path
            )
        )
    }

    func testDeprecatedEmojiFactoryIsAnExplicitEmptyCompatibilityShim() {
        XCTAssertTrue(TextReplacer.withDefaultEmojiDictionary().isEmpty)
    }
}
