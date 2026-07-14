# AzooKeyKanaKanjiConverter — 8key non-Zenzai fork

This is an unofficial public fork maintained for the 8key keyboard extension.
It is not affiliated with or endorsed by the upstream azooKey project.

- Upstream: https://github.com/azooKey/AzooKeyKanaKanjiConverter
- Base release: `v0.11.2`
- Base revision: `80b8204f1cdfb364bb2ed355cf52c7ebb2519a0c`
- Default dictionary revision: `832fbb0d3039dfaa4b2183956f3d96f6b07eec4d`
- Emoji dictionary revision: `08f82252fb90ef8f0949a7e3c554e9e1787ce121`

## Scope

The fork keeps the standard kana-kanji conversion engine, prediction,
learning memory, user dictionary integration, default dictionary, and emoji
dictionary used by 8key. Neural conversion support and its model/runtime
dependencies have been removed, together with the upstream command-line tool.

The only exported Swift Package product is
`KanaKanjiConverterModuleWithDefaultDictionary`. The module name is unchanged
so 8key can continue to import it without an adapter migration.

## Integration

Consumers should pin an audited commit revision rather than a version range.

```swift
.package(
    url: "https://github.com/bigroomfujita/AzooKeyKanaKanjiConverter",
    revision: "<audited-commit-sha>"
)
```

```swift
.product(
    name: "KanaKanjiConverterModuleWithDefaultDictionary",
    package: "AzooKeyKanaKanjiConverter"
)
```

## Verification

Clone with submodules and run the full retained test suite:

```sh
git clone --recursive https://github.com/bigroomfujita/AzooKeyKanaKanjiConverter
cd AzooKeyKanaKanjiConverter
swift test
swift package show-dependencies --format json
```

The dependency graph must contain only `swift-algorithms`,
`swift-collections`, and the transitive `swift-numerics` package.

## License and attribution

The converter source remains available under the upstream MIT License; see
[`LICENSE`](LICENSE). The bundled default dictionary is licensed separately
under Apache License 2.0. The emoji dictionary combines data from Unicode,
CLDR, Mozc, and azooKey; review the submodule documentation and source notices
before redistribution.

Modified files in this fork differ from the upstream v0.11.2 release by
removing functionality and dependencies not used by 8key.
