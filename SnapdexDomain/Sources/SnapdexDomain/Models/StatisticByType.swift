public struct StatisticByType {
    public let type: PokemonType
    public let statistic: Statistic
    
    public init(type: PokemonType, statistic: Statistic) {
        self.type = type
        self.statistic = statistic
    }
}
