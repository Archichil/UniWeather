public enum Language: String, Sendable, CaseIterable {
    case en
    case ru
    case fr
    case de
    case es
    case it
    case zh
    case ja
    case ko

    /// Returns the native name of the language.
    public var nativeName: String {
        switch self {
        case .en: return "English"
        case .ru: return "Русский"
        case .fr: return "Français"
        case .de: return "Deutsch"
        case .es: return "Español"
        case .it: return "Italiano"
        case .zh: return "中文"
        case .ja: return "日本語"
        case .ko: return "한국어"
        }
    }

    /// Returns the string to use in prompts ("на английском", "на русском", и т.д.).
    public var inPrompt: String {
        switch self {
        case .en: return "английском"
        case .ru: return "русском"
        case .fr: return "французском"
        case .de: return "немецком"
        case .es: return "испанском"
        case .it: return "итальянском"
        case .zh: return "китайском"
        case .ja: return "японском"
        case .ko: return "корейском"
        }
    }
}
