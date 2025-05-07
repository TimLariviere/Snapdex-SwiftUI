import SwiftUI

@Observable final class AppSettings {
    var locale: Locale = Locale.current
    
    func setLocale(locale: Locale) {
        self.locale = locale
    }
}
