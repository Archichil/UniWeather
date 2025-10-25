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
        case .en: "English"
        case .ru: "Русский"
        case .fr: "Français"
        case .de: "Deutsch"
        case .es: "Español"
        case .it: "Italiano"
        case .zh: "中文"
        case .ja: "日本語"
        case .ko: "한국어"
        }
    }

    /// Returns the string to use in prompts ("на английском", "на русском", и т.д.).
    public var inPrompt: String {
        switch self {
        case .en: "английском"
        case .ru: "русском"
        case .fr: "французском"
        case .de: "немецком"
        case .es: "испанском"
        case .it: "итальянском"
        case .zh: "китайском"
        case .ja: "японском"
        case .ko: "корейском"
        }
    }
}
