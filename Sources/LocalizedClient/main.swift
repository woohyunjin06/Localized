import Localized

@Localizable
struct Main {
    @Localized(key: Localization.title)
    let titleLabel = Label()
}

struct Label {
    func setLocalized(_ text: String) {}
}

enum Localization {
    static let title = LocalizeKey(
        key: "titleKey",
        argumentsType: (arg1: String, arg2: Int).self
    )
}

