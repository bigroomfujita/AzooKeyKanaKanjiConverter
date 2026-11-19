import Foundation
@testable import KanaKanjiConverterModule
@testable import KanaKanjiConverterModuleWithDefaultDictionary
import XCTest

#if Zenzai || ZenzaiCPU
/// keebo ZN1: モデルを読めない要求は、Zenzai オフと同じ候補を返す。
final class ZN1ZenzaiFallbackTests: XCTestCase {
    private func options(zenzaiMode: ConvertRequestOptions.ZenzaiMode) -> ConvertRequestOptions {
        .init(
            N_best: 10,
            requireJapanesePrediction: .autoMix,
            requireEnglishPrediction: .disabled,
            keyboardLanguage: .ja_JP,
            englishCandidateInRoman2KanaInput: false,
            fullWidthRomanCandidate: false,
            halfWidthKanaCandidate: false,
            learningType: .nothing,
            maxMemoryCount: 0,
            shouldResetMemory: false,
            memoryDirectoryURL: URL(fileURLWithPath: ""),
            sharedContainerURL: URL(fileURLWithPath: ""),
            textReplacer: .empty,
            specialCandidateProviders: [],
            zenzaiMode: zenzaiMode,
            typoCorrectionMode: .disabled,
            metadata: nil
        )
    }

    private struct Snapshot: Equatable {
        var main: [String]
        var prediction: [String]
        var firstClause: [String]
    }

    private func describe(_ candidates: [Candidate]) -> [String] {
        candidates.map { "\($0.text)|\($0.value)|\($0.composingCount)|\($0.data.count)" }
    }

    @MainActor
    private func run(_ reading: String, zenzaiMode: ConvertRequestOptions.ZenzaiMode) -> [Snapshot] {
        let converter = KanaKanjiConverter.withDefaultDictionary()
        let options = self.options(zenzaiMode: zenzaiMode)
        var composingText = ComposingText()
        var snapshots: [Snapshot] = []
        for character in reading {
            composingText.insertAtCursorPosition(String(character), inputStyle: .direct)
            let result = converter.requestCandidates(composingText, options: options)
            snapshots.append(
                Snapshot(
                    main: self.describe(result.mainResults),
                    prediction: self.describe(result.predictionResults),
                    firstClause: self.describe(result.firstClauseResults)
                )
            )
        }
        return snapshots
    }

    private func onMode(weight: URL) -> ConvertRequestOptions.ZenzaiMode {
        .on(weight: weight, inferenceLimit: 10, personalizationMode: nil, versionDependentMode: .v3(.init()))
    }

    @MainActor
    func testMissingModelMatchesZenzaiOff() throws {
        let missing = FileManager.default.temporaryDirectory
            .appendingPathComponent("zn1-missing-\(UUID().uuidString).gguf")
        for reading in ["かんじへんかん", "きょうはいいてんきですね", "はしのはしをわたる"] {
            XCTAssertEqual(self.run(reading, zenzaiMode: self.onMode(weight: missing)), self.run(reading, zenzaiMode: .off), reading)
        }
    }

    @MainActor
    func testCorruptModelMatchesZenzaiOff() throws {
        let corrupt = FileManager.default.temporaryDirectory
            .appendingPathComponent("zn1-corrupt-\(UUID().uuidString).gguf")
        try Data("not a gguf model".utf8).write(to: corrupt)
        defer { try? FileManager.default.removeItem(at: corrupt) }
        for reading in ["かんじへんかん", "ふろばように"] {
            XCTAssertEqual(self.run(reading, zenzaiMode: self.onMode(weight: corrupt)), self.run(reading, zenzaiMode: .off), reading)
        }
    }
}
#endif
