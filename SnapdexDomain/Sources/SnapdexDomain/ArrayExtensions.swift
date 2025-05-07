public extension Array {
    func associate<K, V>(_ transform: (Element) -> (K, V)) -> Dictionary<K, V> {
        return Dictionary(uniqueKeysWithValues: map { transform($0) })
    }
}
