import SwiftUI

public struct SnapdexBackButton: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }
}
