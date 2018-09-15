//
//  AverageViewController.swift
//  Plant
//
//  Created by Olivia Brown on 9/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class AverageViewController: UIViewController {

    private let leafButton = UIButton()
    private let calendarButton = UIButton()
    private let settingsButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.colors.defaultGreen
        setUpBottomButtons()

    }

    private func setUpBottomButtons() {
        // MARK: Leaf Button
        leafButton.setImage(#imageLiteral(resourceName: "leafInUse") , for: .normal)
        leafButton.isEnabled = true
        view.addSubview(leafButton)

        leafButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview().priority(.required)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(UIConstants.layout.leafBottomOffset).priority(.medium)
            make.centerX.equalToSuperview()
        }
        leafButton.addTarget(self, action: #selector(displayServings), for: .touchUpInside)

        // MARK: Calendar Button
        calendarButton.setImage(#imageLiteral(resourceName: "calendarNotInUse") , for: .normal)
        view.addSubview(calendarButton)

        calendarButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.layout.sideButtonEdgeInset)
            make.bottom.equalToSuperview().inset(UIConstants.layout.sideButtonBottomInset)
        }

        // MARK: Settings Button
        settingsButton.setImage(#imageLiteral(resourceName: "settingsNotInUse"), for: .normal)
        view.addSubview(settingsButton)
        settingsButton.addTarget(self, action: #selector(displaySettings), for: .touchUpInside)

        settingsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.layout.sideButtonEdgeInset)
            make.centerY.equalTo(calendarButton)
        }
    }

    @objc func displayServings() {
        navigationController?.view.layer.add(CustomTransitions().transitionToRight, forKey: kCATransition)
        navigationController?.popToRootViewController(animated: false)
    }

    @objc func displaySettings() {
        navigationController?.view.layer.add(CustomTransitions().transitionToRight, forKey: kCATransition)
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

}
