import KeychainAccess
import WordPressAuthenticator

/// Checks and listens for observations when the Apple ID credential is revoked when the user previously signed in with Apple.
///
@available(iOS 13.0, *)
final class AppleIDCredentialChecker {
    /// Keychain access for SIWA auth token
    private lazy var keychain = Keychain(service: WooConstants.keychainServiceName)

    private var cancellable: ObservationToken?

    private lazy var authenticator: WordPressAuthenticator = WordPressAuthenticator.shared
    private let stores: StoresManager

    init(stores: StoresManager = ServiceLocator.stores) {
        self.stores = stores
    }

    func observeLoggedInStateForAppleIDObservations() {
        cancellable = stores.isLoggedIn.subscribe { [weak self] isLoggedIn in
            if isLoggedIn {
                self?.startObservingAppleIDCredentialRevoked()
            } else {
                self?.stopObservingAppleIDCredentialRevoked()
            }
        }
    }

    func checkAppleIDCredentialState() {
        // If not logged in, remove the Apple User ID from the keychain, if it exists.
        guard isLoggedIn() else {
            removeAppleIDFromKeychain()
            return
        }

        // Get the Apple User ID from the keychain
        guard let appleUserID = keychain.wooAppleID else {
            DDLogInfo("checkAppleIDCredentialState: No Apple ID found.")
            return
        }

        // Get the Apple User ID state. If not authorized, log out the account.
        authenticator.getAppleIDCredentialState(for: appleUserID) { [weak self] (state, error) in
            DDLogDebug("checkAppleIDCredentialState: Apple ID state: \(state.rawValue)")

            switch state {
            case .revoked:
                DDLogInfo("checkAppleIDCredentialState: Revoked Apple ID. User signed out.")
                self?.logOutRevokedAppleAccount()
            default:
                // An error exists only for the notFound state.
                // notFound is a valid state when logging in with an Apple account for the first time.
                if let error = error {
                    DDLogDebug("checkAppleIDCredentialState: Apple ID state not found: \(error.localizedDescription)")
                }
                break
            }
        }
    }
}

@available(iOS 13.0, *)
private extension AppleIDCredentialChecker {
    func startObservingAppleIDCredentialRevoked() {
        authenticator.startObservingAppleIDCredentialRevoked { [weak self] in
            guard let self = self else {
                return
            }
            if self.isLoggedIn() {
                DDLogInfo("Apple credentialRevokedNotification received. User signed out.")
                self.logOutRevokedAppleAccount()
            }
        }
    }

    func stopObservingAppleIDCredentialRevoked() {
        authenticator.stopObservingAppleIDCredentialRevoked()
    }

    func logOutRevokedAppleAccount() {
        removeAppleIDFromKeychain()
        DispatchQueue.main.async { [weak self] in
            self?.logout()
        }
    }

    func removeAppleIDFromKeychain() {
        keychain.wooAppleID = nil
    }
}

// MARK: - Authentication helpers
//
@available(iOS 13.0, *)
private extension AppleIDCredentialChecker {
    func isLoggedIn() -> Bool {
        stores.isAuthenticated
    }

    func logout() {
        stores.deauthenticate()
    }
}
