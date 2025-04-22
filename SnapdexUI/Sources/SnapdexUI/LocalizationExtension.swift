import SwiftUI

extension [Locale: String] {
    func translated(_ locale: Locale) -> String {
        let languageCode = locale.language.languageCode?.identifier ?? "en"
        let languageLocale = Locale(identifier: languageCode)
        return self[languageLocale] ?? "NOT_TRANSLATED"
    }
}
