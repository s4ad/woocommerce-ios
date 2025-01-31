/// Order Payment methods
enum OrderPaymentMethod: RawRepresentable {
    /// Booking (confirmed by Shop manager)
    case booking

    /// Cash on Delivery
    case cod

    /// WooCommerce Payments
    case woocommercePayments

    /// No payment method assigned.
    case none

    /// Other
    case unknown

    /// Designated Initializer.
    ///
    public init(rawValue: String) {
        switch rawValue {
        case Keys.booking:
            self = .booking
        case Keys.cod:
            self = .cod
        case Keys.woocommercePayments:
            self = .woocommercePayments
        case Keys.none:
            self = .none
        default:
            self = .unknown
        }
    }

    public var rawValue: String {
        switch self {
        case .booking:
            return Keys.booking
        case .cod:
            return Keys.cod
        case .woocommercePayments:
            return Keys.woocommercePayments
        case .none:
            return Keys.none
        default:
            return Keys.unknown
        }
    }
}


private enum Keys {
    static let booking = "wc-booking-gateway"
    static let cod = "cod"
    static let woocommercePayments = "woocommerce_payments"
    static let none = ""
    static let unknown = "unknown"
}
