import Foundation
import Combine

class IntroViewModel: ObservableObject {
    public static let TotalPageCount = 3
    
    @Published var currentPage: Int = 0
    
    let didFinish = PassthroughSubject<Void, Never>()
    
    func next() {
        if currentPage == IntroViewModel.TotalPageCount - 1 {
            // navigate
            didFinish.send()
        } else {
            currentPage = currentPage + 1
        }
    }
}
