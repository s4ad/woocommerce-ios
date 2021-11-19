import SwiftUI

struct JetpackInstallStepsView: View {
    // Closure invoked when Done button is tapped
    private let dismissAction: () -> Void

    private let siteURL: String

    @ScaledMetric private var scale: CGFloat = 1.0
    @State private var currentStep: JetpackInstallStep = .activation

    private var descriptionAttributedString: NSAttributedString {
        let font: UIFont = .body
        let boldFont: UIFont = font.bold
        let siteName = siteURL.trimHTTPScheme()

        let attributedString = NSMutableAttributedString(
            string: String(format: Localization.installDescription, siteName),
            attributes: [.font: font,
                         .foregroundColor: UIColor.text.withAlphaComponent(0.8)
                        ]
        )
        let boldSiteAddress = NSAttributedString(string: siteName, attributes: [.font: boldFont, .foregroundColor: UIColor.text])
        attributedString.replaceFirstOccurrence(of: siteName, with: boldSiteAddress)
        return attributedString
    }

    init(siteURL: String, dismissAction: @escaping () -> Void) {
        self.siteURL = siteURL
        self.dismissAction = dismissAction
    }

    var body: some View {
        VStack {
            // Main content
            VStack(alignment: .leading, spacing: Constants.contentSpacing) {
                // Header
                HStack(spacing: 8) {
                    Image(uiImage: .jetpackGreenLogoImage)
                        .resizable()
                        .frame(width: Constants.logoSize * scale, height: Constants.logoSize * scale)
                    Image(uiImage: .connectionImage)
                        .resizable()
                        .frame(width: Constants.connectionIconSize * scale, height: Constants.connectionIconSize * scale)

                    if let image = UIImage.wooLogoImage(tintColor: .white) {
                        Circle()
                            .foregroundColor(Color(.withColorStudio(.wooCommercePurple, shade: .shade60)))
                            .frame(width: Constants.logoSize * scale, height: Constants.logoSize * scale)
                            .overlay(
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: Constants.wooIconSize.width * scale, height: Constants.wooIconSize.height * scale)
                            )
                    }

                    Spacer()
                }
                .padding(.top, Constants.contentTopMargin)

                // Title and description
                VStack(alignment: .leading, spacing: Constants.textSpacing) {
                    Text(Localization.installTitle)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(.text))

                    AttributedText(descriptionAttributedString)
                }

                // Install steps
                ForEach(JetpackInstallStep.allCases) { step in
                    HStack(spacing: Constants.stepItemSpacing) {
                        if step == currentStep {
                            ActivityIndicator(isAnimating: .constant(true), style: .medium)
                        }

                        Text(step.title)
                            .font(.body)
                            .if(step <= currentStep) {
                                $0.bold()
                            }
                            .foregroundColor(Color(.text))
                            .opacity(step <= currentStep ? 1 : 0.5)
                    }
                }
            }
            .padding(.horizontal, Constants.contentHorizontalMargin)
            .scrollVerticallyIfNeeded()

            Spacer()

            // Done Button to dismiss Install Jetpack
            Button(Localization.doneButton, action: dismissAction)
                .buttonStyle(PrimaryButtonStyle())
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, Constants.actionButtonMargin)
                .padding(.bottom, Constants.actionButtonMargin)
        }
    }
}

private extension JetpackInstallStepsView {
    enum Constants {
        static let contentTopMargin: CGFloat = 69
        static let contentHorizontalMargin: CGFloat = 40
        static let contentSpacing: CGFloat = 32
        static let logoSize: CGFloat = 40
        static let wooIconSize: CGSize = .init(width: 30, height: 18)
        static let connectionIconSize: CGFloat = 10
        static let textSpacing: CGFloat = 12
        static let actionButtonMargin: CGFloat = 16
        static let stepItemSpacing: CGFloat = 24
        static let stepImageSize: CGFloat = 24
    }

    enum Localization {
        static let installTitle = NSLocalizedString("Install Jetpack", comment: "Title of the Install Jetpack view")
        static let installDescription = NSLocalizedString("Please wait while we connect your site %1$@ with Jetpack.",
                                                          comment: "Message on the Jetpack Install Progress screen. The %1$@ is the site address.")
        static let doneButton = NSLocalizedString("Done", comment: "Done button on the Jetpack Install Progress screen.")
    }
}

struct JetpackInstallStepsView_Previews: PreviewProvider {
    static var previews: some View {
        JetpackInstallStepsView(siteURL: "automattic.com", dismissAction: {})
            .preferredColorScheme(.light)
            .previewLayout(.fixed(width: 414, height: 780))

        JetpackInstallStepsView(siteURL: "automattic.com", dismissAction: {})
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 414, height: 780))
    }
}
