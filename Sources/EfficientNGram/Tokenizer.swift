/// Compatibility API for the optional personal n-gram path in ZN0s.
public struct ZenzTokenizer {
    public init(enableFastTokenizerPath _: Bool = true) {}

    public func encode(text _: String) -> [Int] { [] }
    public func encodeSlow(text _: String) -> [Int] { [] }
    public func decode(tokens _: [Int]) -> String { "" }
    public var startTokenID: Int { 0 }
    public var endTokenID: Int { 0 }
    public var vocabSize: Int { 6000 }
}
