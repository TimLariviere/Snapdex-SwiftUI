public final class PokemonWeaknessCalculator {
    private static let weaknessesMap: [PokemonType: [PokemonType]] = [
        .bug: [.fire, .fighting, .rock],
        .dragon: [.ice, .dragon, .fairy],
        .electric: [.ground],
        .fairy: [.steel, .poison],
        .fighting: [.flying, .psychic, .fairy],
        .fire: [.water, .rock, .ground],
        .flying: [.electric, .rock, .ice],
        .ghost: [.ghost],
        .grass: [ .fire, .ice, .flying, .bug, .poison],
        .ground: [.water, .ice, .grass],
        .ice: [.fire, .fighting, .rock, .steel],
        .normal: [.fighting],
        .poison: [.ground, .psychic],
        .psychic: [.bug, .ghost],
        .rock: [.water, .grass, .fighting, .ground, .steel],
        .steel: [.fire, .fighting, .ground],
        .water: [.electric, .grass]
    ]

    private static let resistancesMap: [PokemonType: [PokemonType]] = [
        .bug: [.grass, .fighting, .ground],
        .dragon: [ .fire, .water, .electric, .grass ],
        .electric: [.electric, .flying, .steel ],
        .fairy: [.fighting, .bug ],
        .fighting: [.bug, .rock ],
        .fire: [ .fire, .grass, .ice, .bug, .steel, .fairy ],
        .flying: [.grass, .flying, .bug],
        .ghost: [.poison, .bug],
        .grass: [ .water, .electric, .grass, .ground ],
        .ground: [.poison, .rock ],
        .ice: [.ice ],
        .poison: [ .grass, .flying, .poison, .fairy ],
        .psychic: [.fighting, .psychic ],
        .rock: [ .normal, .fire, .poison, .flying ],
        .steel: [ .normal, .grass, .ice, .flying, .psychic, .bug, .rock, .dragon, .steel, .fairy ],
        .water: [.fire, .water, .ice, .steel ]
    ]

    private static let immunitiesMap: [PokemonType: [PokemonType]] = [
        .fairy: [.dragon ],
        .flying: [.ground ],
        .ghost: [.normal, .fighting ],
        .ground: [.electric ],
        .normal: [.ghost ],
        .steel: [.poison ]
    ]

    public static func calculateWeaknesses(types: [PokemonType]) -> [PokemonType] {
        var actualWeaknesses = [PokemonType]()

        types.forEach { type in
            if let weakness = weaknessesMap[type] {
                actualWeaknesses.append(contentsOf: weakness)
            }
        }

        types.forEach { type in
            if let weakness = immunitiesMap[type] {
                actualWeaknesses.append(contentsOf: weakness)
            }
            
            if let weakness = resistancesMap[type] {
                actualWeaknesses.append(contentsOf: weakness)
            }
        }

        return actualWeaknesses.reduce(into: [PokemonType]()) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }.sorted(by: { $0.hashValue < $1.hashValue })
    }
}
