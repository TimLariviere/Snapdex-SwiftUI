import Foundation

class IntroViewModel: ObservableObject {
    public static let TotalPageCount = 3
    @Published var currentPage: Int = 0
    
    func next() {
        if currentPage == IntroViewModel.TotalPageCount - 1 {
            // navigate
        } else {
            currentPage = currentPage + 1
        }
    }
}
