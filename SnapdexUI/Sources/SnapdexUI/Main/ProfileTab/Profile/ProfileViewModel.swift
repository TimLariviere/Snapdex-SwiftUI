import SwiftUI
import Combine
import SnapdexDomain
import SnapdexUseCases

@MainActor @Observable final class ProfileViewModel {
    var user: User? = nil
    var aiModel: AIModel = .embedded
    var isBusy: Bool = false
    var error: LocalizedStringKey? = nil
    
    let didLogout = PassthroughSubject<Void, Never>()
    
    @ObservationIgnored private var cancellable: AnyCancellable?
    @ObservationIgnored private var authServicing: AuthServicing
    @ObservationIgnored private var pokemonServicing: PokemonServicing
    
    init(deps: AppDependencies) {
        self.authServicing = deps.authServicing
        self.pokemonServicing = deps.pokemonServicing
        
        self.cancellable = deps.authServicing.getCurrentUserPublisher()
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.user = user
            }
    }
    
    func resetProgress() async {
        isBusy = true
        
        let result = await pokemonServicing.resetForUser(userId: user!.id!)
        
        isBusy = false
        
        switch result {
            case .success(()): ()
            case .failure(let error):
                switch error {
                    case .resetFailed: self.error = "Failed to reset progress"
                }
        }
    }
    
    func deleteAccount() async {
        isBusy = true
        
        let result = await authServicing.deleteCurrentUser()
        
        isBusy = false
        
        switch result {
            case .success(()):
                didLogout.send(())
                
            case .failure(let error):
                switch error {
                    case .deleteFailed: self.error = "Failed to delete current user"
                }
        }
    }
    
    func logout() async {
        await authServicing.logout()
        didLogout.send(())
    }
}
