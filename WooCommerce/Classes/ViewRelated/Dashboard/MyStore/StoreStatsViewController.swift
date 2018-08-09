import UIKit
import Yosemite
import XLPagerTabStrip


// MARK: - MyStoreStatsViewController
//
class StoreStatsViewController: ButtonBarPagerTabStripViewController {

    // MARK: - Properties

    @IBOutlet private weak var topBorder: UIView!
    @IBOutlet private weak var middleBorder: UIView!
    @IBOutlet private weak var bottomBorder: UIView!

    private var periodVCs = [PeriodDataViewController]()

    // MARK: - View Lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        configurePeriodViewControllers()
        configureTabStrip()
        // 👆 must be called before super.viewDidLoad()

        super.viewDidLoad()
        configureView()
    }

    // MARK: - PagerTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return periodVCs
    }
}


// MARK: - User Interface Configuration
//
private extension StoreStatsViewController {

    func configureView() {
        topBorder.backgroundColor = StyleManager.wooGreyBorder
        middleBorder.backgroundColor = StyleManager.wooGreyBorder
        bottomBorder.backgroundColor = StyleManager.wooGreyBorder
    }

    func configurePeriodViewControllers() {
        let child_1 = PeriodDataViewController(granularity: .day)
        let child_2 = PeriodDataViewController(granularity: .week)
        let child_3 = PeriodDataViewController(granularity: .month)
        let child_4 = PeriodDataViewController(granularity: .year)

        periodVCs.append(child_1)
        periodVCs.append(child_2)
        periodVCs.append(child_3)
        periodVCs.append(child_4)
    }

    func configureTabStrip() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = StyleManager.wooCommerceBrandColor
        settings.style.buttonBarItemFont = StyleManager.subheadlineFont
        settings.style.selectedBarHeight = TabStrip.selectedBarHeight
        settings.style.buttonBarItemTitleColor = StyleManager.wooGreyTextMin
        settings.style.buttonBarItemsShouldFillAvailableWidth = false
        settings.style.buttonBarItemLeftRightMargin = TabStrip.buttonLeftRightMargin

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = StyleManager.wooGreyTextMin
            newCell?.label.textColor = StyleManager.wooCommerceBrandColor
        }
    }
}


// MARK: - Private Helpers
//
private extension StoreStatsViewController {

    func periodDataVC(for stat: StatGranularity) -> PeriodDataViewController? {
        return periodVCs.filter({ $0.granularity == stat }).first
    }
}


// MARK: - Constants!
//
private extension StoreStatsViewController {
    enum TabStrip {
        static let buttonLeftRightMargin: CGFloat   = 14.0
        static let selectedBarHeight: CGFloat       = 3.0
    }
}
