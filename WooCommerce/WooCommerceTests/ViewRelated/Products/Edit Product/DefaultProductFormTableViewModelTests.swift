import XCTest
import Yosemite

@testable import WooCommerce

final class DefaultProductFormTableViewModelTests: XCTestCase {
    func test_simple_product_inventory_row_details_shows_stock_status_when_stock_management_is_disabled_without_sku() {
        // Arrange
        let product = Product.fake().copy(productTypeKey: ProductType.simple.rawValue,
                                          sku: "",
                                          manageStock: false,
                                          stockStatusKey: ProductStockStatus.onBackOrder.rawValue)
        let model = EditableProductModel(product: product)
        let actionsFactory = ProductFormActionsFactory(product: model, formType: .edit)

        // Action
        let tableViewModel = DefaultProductFormTableViewModel(product: model, actionsFactory: actionsFactory, currency: "")

        // Assert
        guard case let .settings(rows) = tableViewModel.sections[1] else {
            XCTFail("Unexpected section at index 1: \(tableViewModel.sections)")
            return
        }
        var inventoryViewModel: ProductFormSection.SettingsRow.ViewModel?
        for row in rows {
            if case let .inventory(viewModel, _) = row {
                inventoryViewModel = viewModel
                break
            }
        }
        XCTAssertEqual(inventoryViewModel?.details, ProductStockStatus.onBackOrder.description)
    }

    func test_variable_product_inventory_row_has_no_details_when_stock_management_is_disabled_without_sku() {
        // Arrange
        let product = Product.fake().copy(productTypeKey: ProductType.variable.rawValue,
                                          sku: "",
                                          manageStock: false,
                                          stockStatusKey: ProductStockStatus.onBackOrder.rawValue)
        let model = EditableProductModel(product: product)
        let actionsFactory = ProductFormActionsFactory(product: model, formType: .edit)

        // Action
        let tableViewModel = DefaultProductFormTableViewModel(product: model, actionsFactory: actionsFactory, currency: "")

        // Assert
        guard case let .settings(rows) = tableViewModel.sections[1] else {
            XCTFail("Unexpected section at index 1: \(tableViewModel.sections)")
            return
        }
        var inventoryViewModel: ProductFormSection.SettingsRow.ViewModel?
        for row in rows {
            if case let .inventory(viewModel, _) = row {
                inventoryViewModel = viewModel
                break
            }
        }
        XCTAssertNil(inventoryViewModel?.details)
    }

    func test_variation_view_model_image_row_has_isVariation_true() {
        // Arrange
        let variation = ProductVariation.fake()
        let model = EditableProductVariationModel(productVariation: variation)
        let actionsFactory = ProductVariationFormActionsFactory(productVariation: model, editable: true)

        // Action
        let tableViewModel = DefaultProductFormTableViewModel(product: model, actionsFactory: actionsFactory, currency: "")

        // Assert
        guard case let .primaryFields(rows) = tableViewModel.sections[0] else {
            XCTFail("Unexpected section at index 0: \(tableViewModel.sections)")
            return
        }

        var isVariation: Bool?
        for row in rows {
            if case .images(_, _, let isVariationValue) = row {
                isVariation = isVariationValue
                break
            }
        }

        if let isVariation = isVariation {
            XCTAssertTrue(isVariation)
        } else {
            XCTFail("Cell not found")
        }
    }

    func test_product_view_model_image_row_has_isVariation_false() {
        // Arrange
        let product = Product.fake().copy(productTypeKey: ProductType.simple.rawValue
        )
        let model = EditableProductModel(product: product)
        let actionsFactory = ProductFormActionsFactory(product: model, formType: .edit)


        // Action
        let tableViewModel = DefaultProductFormTableViewModel(product: model, actionsFactory: actionsFactory, currency: "")

        // Assert
        guard case let .primaryFields(rows) = tableViewModel.sections[0] else {
            XCTFail("Unexpected section at index 0: \(tableViewModel.sections)")
            return
        }

        var isVariation: Bool?
        for row in rows {
            if case .images(_, _, let isVariationValue) = row {
                isVariation = isVariationValue
                break
            }
        }

        if let isVariation = isVariation {
            XCTAssertFalse(isVariation)
        } else {
            XCTFail("Cell not found")
        }
    }
}
