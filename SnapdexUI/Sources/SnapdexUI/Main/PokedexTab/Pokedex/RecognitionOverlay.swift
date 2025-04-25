import SwiftUI
import SnapdexDesignSystem

struct PokemonCaught {
    let id: Int
    let name: [Locale: String]
}

struct RecognitionState {
    let isRecognizing: Bool
    let caught: PokemonCaught?
}

struct RecognitionOverlay: View {
    let state: RecognitionState
    let onDismiss: () -> Void
    
    @Environment(\.theme) private var theme
    @Environment(\.locale) private var locale
    
    init(state: RecognitionState, onDismiss: @escaping () -> Void) {
        self.state = state
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            if state.isRecognizing {
                recognitionInProgress
            } else if let pokemon = state.caught {
                pokemonCaught(pokemon: pokemon)
            } else {
                nothingCaught
            }
        }
        .padding(.all, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.shadow)
        .foregroundStyle(Color.white)
    }
    
    var recognitionInProgress: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(theme.colors.primary)
            
            Text("Capturing pokemon...")
        }
    }
    
    func pokemonCaught(pokemon: PokemonCaught) -> some View {
        VStack(spacing: 24) {
            Text("Congratulations")
                .fontStyle(theme.typography.heading2)
            
            Text("You've just caught")
            
            GIFImage(gifName: String(format: "Pokemon%04d", pokemon.id), bundle: .module)
                .frame(height: 400)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 0) {
                Text(pokemon.name.translated(locale))
                    .fontStyle(theme.typography.heading1)
                
                Text(String(format: "Nº%04d", pokemon.id))
                    .fontStyle(theme.typography.smallLabel)
            }
            
            SnapdexPrimaryButton("Awesome!") {
                onDismiss()
            }
        }
        .background(
            Circle()
                .fill(Color.black)
                .blur(radius: 60)
        )
    }
    
    var nothingCaught: some View {
        VStack(spacing: 24) {
            Text("Uh oh, there's no one here...")
                .fontStyle(theme.typography.heading2)
                .multilineTextAlignment(.center)
            
            Text("?")
                .fontStyle(theme.typography.heading1.withSize(120))
            
            Text("Couldn't find a pokemon in your picture.\nYou must have just missed it!")
                .multilineTextAlignment(.center)
            
            SnapdexPrimaryButton("Try again") {
                onDismiss()
            }
        }
        .background(
            Circle()
                .fill(Color.black)
                .blur(radius: 60)
        )
    }
}

#Preview {
    AppTheme {
        RecognitionOverlay(state: RecognitionState(isRecognizing: false, caught: PokemonCaught(id: 1, name: [Locale(identifier: "en"): "Bulbasaur"]))) {
            
        }
    }
}
