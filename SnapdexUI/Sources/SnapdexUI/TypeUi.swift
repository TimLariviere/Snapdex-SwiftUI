import SwiftUI
import SnapdexDomain

struct TypeUi {
    let name: LocalizedStringKey
    let color: Color
    let image: Image
    
    static func fromType(_ type: PokemonType) -> TypeUi {
        return switch type {
            case .bug: TypeUi(name: "Bug", color: Color("Bug", bundle: .module), image: Image("Bug", bundle: .module))
            case .dragon: TypeUi(name: "Dragon", color: Color("Dragon", bundle: .module), image: Image("Dragon", bundle: .module))
            case .electric: TypeUi(name: "Electric", color: Color("Electric", bundle: .module), image: Image("Electric", bundle: .module))
            case .fairy: TypeUi(name: "Fairy", color: Color("Fairy", bundle: .module), image: Image("Fairy", bundle: .module))
            case .figthing: TypeUi(name: "Fighting", color: Color("Fighting", bundle: .module), image: Image("Fighting", bundle: .module))
            case .fire: TypeUi(name: "Fire", color: Color("Fire", bundle: .module), image: Image("Fire", bundle: .module))
            case .flying: TypeUi(name: "Flying", color: Color("Flying", bundle: .module), image: Image("Flying", bundle: .module))
            case .ghost: TypeUi(name: "Ghost", color: Color("Ghost", bundle: .module), image: Image("Ghost", bundle: .module))
            case .grass: TypeUi(name: "Grass", color: Color("Grass", bundle: .module), image: Image("Grass", bundle: .module))
            case .ground: TypeUi(name: "Ground", color: Color("Ground", bundle: .module), image: Image("Ground", bundle: .module))
            case .ice: TypeUi(name: "Ice", color: Color("Ice", bundle: .module), image: Image("Ice", bundle: .module))
            case .normal: TypeUi(name: "Normal", color: Color("Normal", bundle: .module), image: Image("Normal", bundle: .module))
            case .poison: TypeUi(name: "Poison", color: Color("Poison", bundle: .module), image: Image("Poison", bundle: .module))
            case .psychic: TypeUi(name: "Psychic", color: Color("Psychic", bundle: .module), image: Image("Psychic", bundle: .module))
            case .rock: TypeUi(name: "Rock", color: Color("Rock", bundle: .module), image: Image("Rock", bundle: .module))
            case .steel: TypeUi(name: "Steel", color: Color("Steel", bundle: .module), image: Image("Steel", bundle: .module))
            case .water: TypeUi(name: "Water", color: Color("Water", bundle: .module), image: Image("Water", bundle: .module))
        }
    }
}
