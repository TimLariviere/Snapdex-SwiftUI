import SwiftUI
import MarkdownUI
import SnapdexDesignSystem

struct PrivacyPolicyScreen: View {
    @Environment(\.theme) private var theme
    @Environment(NavBarVisibility.self) private var navBarVisibility
    
    var body: some View {
        SnapdexScaffold(title: "Privacy policy") {
            GeometryReader { geo in
                ScrollView {
                    Markdown(loadMarkdown(named: "PrivacyPolicy"))
                        .markdownTextStyle {
                            FontFamily(.custom(theme.typography.paragraph.fontFamily.rawValue))
                            FontSize(CGFloat(theme.typography.paragraph.fontSize))
                            FontWeight(theme.typography.paragraph.fontWeight)
                            ForegroundColor(theme.colors.onBackground)
                        }
                        .markdownTextStyle(\.link) {
                            ForegroundColor(theme.colors.primary)
                        }
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity, minHeight: geo.size.height, maxHeight: .infinity)
                }
            }
        }
        .onAppear {
            navBarVisibility.isVisible = false
        }
    }
    
    func loadMarkdown(named fileName: String) -> String {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "md"),
              let contents = try? String(contentsOf: url, encoding: .utf8) else {
            return "Failed to load content"
        }
        return contents
    }
}

#Preview {
    AppTheme {
        PrivacyPolicyScreen()
    }
}
