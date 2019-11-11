import UIKit

extension UIColor {
    /// Get a UIColor from the Muriel color palette
    ///
    /// - Parameters:
    ///   - color: an instance of a MurielColor
    /// - Returns: UIColor. Red in cases of error
    class func muriel(color murielColor: MurielColor) -> UIColor {
        let assetName = murielColor.assetName()
        let color: UIColor?

        // This is temporary work around as there's a bug in the
        // GM seed of Xcode 11 which causes loading colors from asset
        // catalogs to fail (54325712)
        if #available(iOS 12.0, *) {
            color = UIColor(named: assetName)
        } else {
            color = MurielPalette.color(from: assetName)
        }

        guard let unwrappedColor = color else {
            return .red
        }

        return unwrappedColor
    }
    /// Get a UIColor from the Muriel color palette, adjusted to a given shade
    /// - Parameter color: an instance of a MurielColor
    /// - Parameter shade: a MurielColorShade
    class func muriel(color: MurielColor, _ shade: MurielColorShade) -> UIColor {
        let newColor = MurielColor(from: color, shade: shade)
        return muriel(color: newColor)
    }
}


// MARK: - Domain colors. 
extension UIColor {
    /// Muriel brand color
    static var brand = UIColor(light: muriel(color: .wooCommercePurple, .shade60),
                               dark: muriel(color: .wooCommercePurple, .shade30))

}


// MARK: - Grays
extension UIColor {
    /// Muriel gray palette
    /// - Parameter shade: a MurielColorShade of the desired shade of gray
    class func gray(_ shade: MurielColorShade) -> UIColor {
        return muriel(color: .gray, shade)
    }

    /// Muriel neutral colors, which invert in dark mode
    /// - Parameter shade: a MurielColorShade of the desired neutral shade
    static var neutral: UIColor {
        return neutral(.shade50)
    }
    class func neutral(_ shade: MurielColorShade) -> UIColor {
        switch shade {
        case .shade0:
            return UIColor(light: muriel(color: .gray, .shade0), dark: muriel(color: .gray, .shade100))
            case .shade5:
            return UIColor(light: muriel(color: .gray, .shade5), dark: muriel(color: .gray, .shade90))
            case .shade10:
            return UIColor(light: muriel(color: .gray, .shade10), dark: muriel(color: .gray, .shade80))
            case .shade20:
            return UIColor(light: muriel(color: .gray, .shade20), dark: muriel(color: .gray, .shade70))
            case .shade30:
            return UIColor(light: muriel(color: .gray, .shade30), dark: muriel(color: .gray, .shade60))
            case .shade40:
            return UIColor(light: muriel(color: .gray, .shade40), dark: muriel(color: .gray, .shade50))
            case .shade50:
            return UIColor(light: muriel(color: .gray, .shade50), dark: muriel(color: .gray, .shade40))
            case .shade60:
            return UIColor(light: muriel(color: .gray, .shade60), dark: muriel(color: .gray, .shade30))
            case .shade70:
            return UIColor(light: muriel(color: .gray, .shade70), dark: muriel(color: .gray, .shade20))
            case .shade80:
            return UIColor(light: muriel(color: .gray, .shade80), dark: muriel(color: .gray, .shade10))
            case .shade90:
            return UIColor(light: muriel(color: .gray, .shade90), dark: muriel(color: .gray, .shade5))
            case .shade100:
            return UIColor(light: muriel(color: .gray, .shade100), dark: muriel(color: .gray, .shade0))
        }
    }
}


// MARK: - UI elements
extension UIColor {
    /// The most basic background: white in light mode, black in dark mode
    static var basicBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        }
        return .white
    }

    /// Default text color: high contrast
    static var defaultTextColor: UIColor {
        if #available(iOS 13, *) {
            return .label
        }

        return UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    }

    static var secondaryTextColor: UIColor {
        if #available(iOS 13, *) {
            return .secondaryLabel
        }

        return UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    }

    static var highlightTextColor: UIColor {
        return UIColor(light: muriel(color: .blue, .shade50) ,
                        dark: muriel(color: .blue, .shade30))
    }

    static var announcementDotColor: UIColor {
        return UIColor(light: muriel(color: .red, .shade50),
                       dark: muriel(color: .red, .shade50))
    }


    /// Muriel/iOS navigation color
    static var appBar = UIColor.brand

    // MARK: - Table Views

    /// Color for table foregrounds (cells, etc)
    static var listForeground: UIColor {
        if #available(iOS 13, *) {
            return .secondarySystemGroupedBackground
        }

        return .white
    }

    /// Color for table backgrounds (cells, etc)
    static var listBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemGroupedBackground
        }

        return muriel(color: .gray, .shade0)
    }

    /// For icons that are present in a table view, or similar list
    static var listIcon: UIColor {
        if #available(iOS 13, *) {
            return .secondaryLabel
        }

        return .neutral(.shade20)
    }

    /// For icons that are present in a toolbar or similar view
    static var toolbarInactive: UIColor {
        if #available(iOS 13, *) {
               return .secondaryLabel
           }

        return .neutral(.shade30)
    }

    /// Note: these values are intended to match the iOS defaults
    static var tabUnselected: UIColor =  UIColor(light: UIColor(hexString: "999999"), dark: UIColor(hexString: "757575"))

}

extension UIColor {
    // A way to create dynamic colors that's compatible with iOS 11 & 12
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13, *) {
            self.init { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        } else {
            // in older versions of iOS, we assume light mode
            self.init(color: light)
        }
    }

    convenience init(color: UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIColor {
    func color(for trait: UITraitCollection?) -> UIColor {
        if #available(iOS 13, *), let trait = trait {
            return resolvedColor(with: trait)
        }
        return self
    }
}
