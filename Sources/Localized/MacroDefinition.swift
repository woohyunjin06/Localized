@attached(peer, names: suffixed(Arguments), arbitrary)
public macro Localized<Key>(key: LocalizeKey<Key>) = #externalMacro(module: "LocalizedMacros", type: "LocalizedMacro")

#if canImport(UIKit)
import UIKit
@attached(peer, names: suffixed(Arguments), arbitrary)
public macro LocalizedButton<Key>(key: LocalizeKey<Key>, for state: UIButton.State) = #externalMacro(module: "LocalizedMacros", type: "LocalizedButtonMacro")
#endif

@attached(member, names: named(localize))
public macro Localizable() = #externalMacro(module: "LocalizedMacros", type: "LocalizableMacro")
