import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import LocalizedMacros

let testMacros: [String: Macro.Type] = [
    "Localizable": LocalizableMacro.self,
    "Localized": LocalizedMacro.self,
    "LocalizedButton": LocalizedButtonMacro.self,
]

final class LocalizedTests: XCTestCase {
    
    func testLocalizedMacro() {
        assertMacroExpansion(
            """
            @Localizable
            class ViewController: UIViewController {
                @Localized(key: Localizable.title)
                let titleLabel = UILabel()
            
                @Localized(key: Localizable.subtitle)
                let subtitleLabel = UILabel()
            }
            """,
            expandedSource: """
            class ViewController: UIViewController {
                let titleLabel = UILabel()

                var titleLabelArguments = makeNil(ofType: Localizable.title.argumentsType) {
                    didSet {
                        localizeTitleLabel()
                    }
                }

                func localizeTitleLabel() {
                    if let titleLabelArguments {
                        titleLabel.setLocalized(Localizable.title.localized(arguments: titleLabelArguments))
                    }
                }
                let subtitleLabel = UILabel()

                var subtitleLabelArguments = makeNil(ofType: Localizable.subtitle.argumentsType) {
                    didSet {
                        localizeSubtitleLabel()
                    }
                }

                func localizeSubtitleLabel() {
                    if let subtitleLabelArguments {
                        subtitleLabel.setLocalized(Localizable.subtitle.localized(arguments: subtitleLabelArguments))
                    }
                }

                func localize() {
                    localizeTitleLabel()
                    localizeSubtitleLabel()
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testLocalizedButtonMacro() {
        assertMacroExpansion(
            """
            @Localizable
            class ViewController: UIViewController {
                @LocalizedButton(key: Localizable.confirm, for: .normal)
                let confirmButton = UIButton()
            
                @LocalizedButton(key: Localizable.cancel, for: UIButton.State.normal)
                let cancelButton = UIButton()
            }
            """,
            expandedSource: """
            class ViewController: UIViewController {
                let confirmButton = UIButton()

                var confirmButtonArguments = makeNil(ofType: Localizable.confirm.argumentsType) {
                    didSet {
                        localizeConfirmButton()
                    }
                }

                func localizeConfirmButton() {
                    if let confirmButtonArguments {
                        confirmButton.setTitle(Localizable.confirm.localized(arguments: confirmButtonArguments), for: .normal)
                    }
                }
                let cancelButton = UIButton()

                var cancelButtonArguments = makeNil(ofType: Localizable.cancel.argumentsType) {
                    didSet {
                        localizeCancelButton()
                    }
                }

                func localizeCancelButton() {
                    if let cancelButtonArguments {
                        cancelButton.setTitle(Localizable.cancel.localized(arguments: cancelButtonArguments), for: UIButton.State.normal)
                    }
                }

                func localize() {
                    localizeConfirmButton()
                    localizeCancelButton()
                }
            }
            """,
            macros: testMacros
        )
    }
}
