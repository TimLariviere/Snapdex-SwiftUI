import SwiftUI
import SnapdexDesignSystem

public struct IntroScreen: View {
    public init() {}
    
    public var body: some View {
        SnapdexBackground {
            Text("Intro Hallo")
        }
    }
}

#Preview {
    IntroScreen()
}
