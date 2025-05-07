import SwiftUI
import Combine
import SnapdexDomain
import SnapdexUseCases

@MainActor @Observable final class NewNameViewModel {
    var name: String {
        didSet {
            validateForm()
        }
    }
    var canChangeName: Bool
    var isChangingName: Bool
    var error: String?
    
    @ObservationIgnored let didChangeName = PassthroughSubject<Void, Never>()
    
    @ObservationIgnored private let userDataValidator: UserDataValidator
    @ObservationIgnored private let userServicing: UserServicing
    
    init(deps: AppDependencies) {
        self.userDataValidator = deps.userDataValidator
        self.userServicing = deps.userServicing
        
        self.name = ""
        self.canChangeName = false
        self.isChangingName = false
        self.error = nil
    }
    
    private func validateForm() {
        canChangeName = userDataValidator.validateName(name)
    }
    
    func setName() async {
        isChangingName = true
        let result = await userServicing.changeName(newName: name)
        isChangingName = false
        
        switch result {
            case .success(()): didChangeName.send(())
            case .failure(let error):
                switch error {
                    case .changeFailed: self.error = "Could not change name"
                }
        }
    }
}
