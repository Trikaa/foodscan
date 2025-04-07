import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
            Bundle.setLanguage(currentLanguage)
            objectWillChange.send() // Обновить весь интерфейс
        }
    }
    
    private init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage")
        self.currentLanguage = savedLanguage ?? Locale.current.language.languageCode?.identifier ?? "en"
        Bundle.setLanguage(currentLanguage)
    }
}
