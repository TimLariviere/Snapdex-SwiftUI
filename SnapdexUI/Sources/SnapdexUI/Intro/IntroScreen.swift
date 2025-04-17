import SwiftUI
import SnapdexDesignSystem

public struct IntroScreen: View {
    @State private var viewModel = IntroViewModel()
    private let didComplete: @MainActor () -> Void
    
    public init(didComplete: @MainActor @escaping () -> Void) {
        self.didComplete = didComplete
    }
    
    public var body: some View {
        SnapdexBackground {
            VStack(spacing: 36) {
                SnapdexCarousel(pageCount: IntroViewModel.PAGE_COUNT, currentPage: $viewModel.currentPage) { index in
                    VStack {
                        let (image, description) = getDetail(index: index)
                        
                        Image(image, bundle: .module)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: .infinity)
                        
                        Text(description)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
                
                SnapdexIndicatorView(
                    pageCount: IntroViewModel.PAGE_COUNT,
                    currentPage: $viewModel.currentPage
                )
                
                let isLastPage = viewModel.currentPage == IntroViewModel.PAGE_COUNT - 1
                SnapdexPrimaryButton(!isLastPage ? "Next" : "Gotta snap'em all!") {
                    if (!isLastPage) {
                        viewModel.next()
                    } else {
                        didComplete()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
    
    func getDetail(index: Int) -> (String, LocalizedStringKey) {
        switch index {
            case 0:
                return ("Intro1", "Capture pokemon in real life by snapping them with Snapdex.")
            case 1:
                return ("Intro2", "Plushes, trading cards, anime, games…\nAny pokemon seen can be captured.")
            default:
                return ("Intro3", "Snapdex will automatically recognize the Pokémon and add it to your Pokedex.")
        }
    }
}

#Preview {
    AppTheme {
        IntroScreen(didComplete: {})
    }
}
