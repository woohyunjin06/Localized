
# Localized

`Localized` simplifies the process of localizing views such as `UILabel` in your iOS projects. It automates the generation of boilerplate code, making your codebase cleaner, more maintainable, and type-safe.

```swift
import Localized

@Localizable
final class MainViewController: UIViewController {
    @Localized(key: Localization.description)
    let descriptionLabel = UILabel()

    func didReceiveResponse(_ response: Response) {
        descriptionLabel.argument = (id: response.id, count: response.count)
    }

    func didChangeLanguage() {
        localize()
    }
}
```

# Usage
- Define localize key
    ```swift
    enum Localization {
        static let title = LocalizeKey(
            key: "title_key",
            argumentsType: (stringArg: String, integerArg: Int).self
        )
    }
    ```
- Localize UILabel
   ```swift
   import Localized

    @Localizable
    final class MainViewController: UIViewController {
        @Localized(key: Localization.title)
        let titleLabel = UILabel()
    }
    ```

    This will generate the following boilerplate code for you:
    ```swift
    var titleLabelArguments = makeNil(ofType: Localization.title.argumentsType) {
        didSet {
            localizeTitleLabel()
        }
    }

    func localizeTitleLabel() {
        if let titleLabelArguments = titleLabelArguments {
            titleLabel.setLocalized(Localization.title.localized(arguments: titleLabelArguments))
        }
    }

    func localize() {
        localizeTitleLabel()
    }
    ```

- Localize UIButton
   ```swift
   import Localized

    @Localizable
    final class MainViewController: UIViewController {
        @LocalizedButton(key: Localization.confirm, for: .normal)
        let confirmButton = UIButton()
    }
    ```
    Now whenever you need to update the localizations, you can call the `localize()` function at any time.

# Installation

## Swift Package Manager

In `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/woohyunjin06/Localized.git", from: "1.0.0")
]
```

And then add the dependency to your targets.

# Contributing
Feel free to open issues or submit pull requests. Your contributions are welcome!

# License
Copyable is available under the MIT license. See the [LICENSE](LICENSE) for details.
