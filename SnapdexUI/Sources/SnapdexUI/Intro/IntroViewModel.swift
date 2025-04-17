import SwiftUI

@Observable class IntroViewModel {
    static let PAGE_COUNT = 3
    var currentPage = 0
    
    func next() {
        currentPage = currentPage + 1
    }
}
