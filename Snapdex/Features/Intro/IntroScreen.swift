import SwiftUI
import Combine

struct IntroScreen: View {
    private let onContinue: () -> Void
    
    @StateObject private var viewModel = IntroViewModel()
    @State private var cancellables = Set<AnyCancellable>()
    
    init(onContinue: @escaping () -> Void) {
        self.onContinue = onContinue
    }
    
    var body: some View {
        SnapdexBackground {
            VStack(spacing: 36) {
                SnapdexCarousel(
                    pageCount: IntroViewModel.TotalPageCount,
                    currentPage: $viewModel.currentPage
                ) { index in
                    let (image, description) = getDetail(index: index)
                    
                    VStack {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        Text(description)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                }
                
                SnapdexIndicatorView(
                    pageCount: IntroViewModel.TotalPageCount,
                    currentPage: $viewModel.currentPage
                )
                
                let isLastPage = viewModel.currentPage == IntroViewModel.TotalPageCount - 1
                SnapdexPrimaryButton(isLastPage ? "Next" : "Gotta snap'em all!") {
                    viewModel.next()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            viewModel.didFinish
                .sink { _ in onContinue() }
                .store(in: &cancellables)
        }
    }
    
    func getDetail(index: Int) -> (String, LocalizedStringResource) {
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
    PreviewView {
        IntroScreen(onContinue: {})
    }
}
