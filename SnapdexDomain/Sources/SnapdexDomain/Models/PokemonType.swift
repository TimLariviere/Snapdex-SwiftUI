public enum PokemonType {
    case bug
    case dragon
    case electric
    case fairy
    case figthing
    case fire
    case flying
    case ghost
    case grass
    case ground
    case ice
    case normal
    case poison
    case psychic
    case rock
    case steel
    case water
}

public extension PokemonType {
    static func fromInt(value: Int) -> PokemonType {
        switch value {
            case 1: .dragon
            case 2: .electric
            case 3: .fairy
            case 4: .figthing
            case 5: .fire
            case 6: .flying
            case 7: .ghost
            case 8: .grass
            case 9: .ground
            case 10: .ice
            case 11: .normal
            case 12: .poison
            case 13: .psychic
            case 14: .rock
            case 15: .steel
            case 16: .water
            default: .bug
        }
    }
}
