//
//  Created by Александр on 6.02.Constants.insets.left19
//  Copyright © Constants.insets.left19 Home. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {

    private enum Constants {
        static let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    private let labelFont = UIFont(name: "Arial", size: 25.0)

    typealias Dependencies = HasSettingsService
    private let dependencies: Dependencies

    private lazy var unitsLabel: UILabel = {
        let label = UILabel()
        label.text = "Units"
        label.textAlignment = .center
        label.font = labelFont
        return label
    }()

    private lazy var unitsSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "IMPERIAL", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "METRIC", at: 1, animated: true)
        segmentedControl.tintColor = UIColor.black
        segmentedControl.selectedSegmentIndex = 1
        let font = UIFont(name: "Arial", size: 15.0)!
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segmentedControl.addTarget(self, action: #selector(changedSegmentedControl), for: .valueChanged)
        return segmentedControl
    }()

    private lazy var contactDeveloperButton: UIButton = {
        let button = UIButton()
        button.setTitle("contact developer", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = labelFont
        button.addTarget(self, action: #selector(contactDeveloperButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "\u{24B8} 2019 My Home all rights reserved)))"
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 15.0)
        return label
    }()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(unitsLabel)
        view.addSubview(unitsSegmentedControl)
        view.addSubview(contactDeveloperButton)
        view.addSubview(informationLabel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = view.bounds.width - Constants.insets.left - Constants.insets.right
        let height = view.bounds.height
        unitsLabel.frame = CGRect(x: Constants.insets.left,
                                  y: Constants.insets.top + safeAreaInsets.top,
                                  width: width, height: 25)

        unitsSegmentedControl.frame = CGRect(x: 70,
                                             y: unitsLabel.frame.maxY + 10,
                                             width: width - 100,
                                             height: height * 0.06)

        informationLabel.frame = CGRect(x: Constants.insets.left,
                                        y: view.bounds.height - safeAreaInsets.bottom - 30,
                                        width: width, height: 15)

        contactDeveloperButton.frame = CGRect(x: Constants.insets.left,
                                              y: informationLabel.frame.minY - 30,
                                              width: width, height: 20)
    }

    @objc private func changedSegmentedControl(_ sender: UISegmentedControl) {
        dependencies.settingsService.setUnitsIndex(index: unitsSegmentedControl.selectedSegmentIndex)
    }

    @objc private func contactDeveloperButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: Bundle.main.appName, message: "xov400@gmail.com",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}
