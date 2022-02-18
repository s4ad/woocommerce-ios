import SwiftUI

/// View to add/edit a single shipping line in an order, with the option to remove it.
///
struct ShippingLineDetails: View {

    /// View model to drive the view content
    ///
    @ObservedObject var viewModel: ShippingLineDetailsViewModel

    /// Defines if the amount input text field should be focused. Defaults to `true`
    ///
    @State private var focusAmountInput: Bool = true

    @Environment(\.presentationMode) var presentation

    @Environment(\.safeAreaInsets) var safeAreaInsets: EdgeInsets

    init(viewModel: ShippingLineDetailsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        let shippingAmount = Binding<String>(get: {
            // This almost works, but it doesn't respect the store's "Number of decimals" setting
            viewModel.formattedAmount
        }, set: {
            viewModel.amount = viewModel.priceFieldFormatter.formatAmount($0)
        })

        NavigationView {
            ScrollView {
                VStack(spacing: .zero) {
                    Section {
                        Group {
                            TitleAndTextFieldRow(title: Localization.amountField,
                                                 placeholder: viewModel.formattedAmount,
                                                 text: shippingAmount,
                                                 symbol: nil,
                                                 keyboardType: .decimalPad)

                            Divider()
                                .padding(.leading, Layout.dividerPadding)

                            TitleAndTextFieldRow(title: Localization.nameField,
                                                 placeholder: ShippingLineDetailsViewModel.Localization.namePlaceholder,
                                                 text: $viewModel.methodTitle,
                                                 symbol: nil,
                                                 keyboardType: .default)
                        }
                        .padding(.horizontal, insets: safeAreaInsets)
                        .addingTopAndBottomDividers()
                    }
                    .background(Color(.listForeground))

                    Spacer(minLength: Layout.sectionSpacing)

                    if viewModel.isExistingShippingLine {
                        Section {
                            Button(Localization.remove) {
                                viewModel.didSelectSave(nil)
                                presentation.wrappedValue.dismiss()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(Color(.error))
                            .padding(.horizontal, insets: safeAreaInsets)
                            .addingTopAndBottomDividers()
                        }
                        .background(Color(.listForeground))
                    }
                }
            }
            .background(Color(.listBackground))
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
            .navigationTitle(viewModel.isExistingShippingLine ? Localization.shipping : Localization.addShipping)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Localization.close) {
                        presentation.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(Localization.done) {
                        viewModel.saveData()
                        presentation.wrappedValue.dismiss()
                    }
                    .disabled(viewModel.shouldDisableDoneButton)
                }
            }
        }
        .wooNavigationBarStyle()
    }
}

// MARK: Constants
private extension ShippingLineDetails {
    enum Layout {
        static let sectionSpacing: CGFloat = 16.0
        static let dividerPadding: CGFloat = 16.0
    }

    enum Localization {
        static let addShipping = NSLocalizedString("Add Shipping", comment: "Title for the Shipping Line screen during order creation")
        static let shipping = NSLocalizedString("Shipping", comment: "Title for the Shipping Line Details screen during order creation")

        static let amountField = NSLocalizedString("Amount", comment: "Title for the amount field on the Shipping Line Details screen during order creation")
        static let nameField = NSLocalizedString("Name", comment: "Title for the name field on the Shipping Line Details screen during order creation")

        static let close = NSLocalizedString("Close", comment: "Text for the close button in the Shipping Line Details screen")
        static let done = NSLocalizedString("Done", comment: "Text for the done button in the Shipping Line Details screen")
        static let remove = NSLocalizedString("Remove Shipping from Order",
                                              comment: "Text for the button to remove a shipping line from the order during order creation")
    }
}

struct ShippingLineDetails_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = NewOrderViewModel.PaymentDataViewModel(itemsTotal: "5",
                                                               shouldShowShippingTotal: true,
                                                               shippingTotal: "10",
                                                               shippingMethodTitle: "Shipping",
                                                               orderTotal: "15")
        ShippingLineDetails(viewModel: .init(inputData: viewModel, didSelectSave: { _ in }))
    }
}
