//
//  AverageViewController.swift
//  Plant
//
//  Created by Olivia Brown on 9/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit
import SnapKit

class AverageViewController: UIViewController {

    private let tableView = UITableView()
    private let leafButton = UIButton()
    private let calendarButton = UIButton()
    private let settingsButton = UIButton()
    private var averageServings: ServingsManager.AverageServing!
    private let appDelegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.colors.defaultGreen
        setUpBottomButtons()

        averageServings = appDelegate.servingsManager.fetchWeeklyAverage()

        let titleLabel = UILabel()
        titleLabel.text = "Weekly Average"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        let averageLabel = UILabel()
        averageLabel.text = "\(averageServings.totalCompleted)%"
        averageLabel.font = UIFont.systemFont(ofSize: 70, weight: .black)
        averageLabel.textColor = .white
        view.addSubview(averageLabel)

        averageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
        }

        let captionLabel = UILabel()
        captionLabel.text = "fully completed"
        captionLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        captionLabel.textColor = .white
        view.addSubview(captionLabel)

        captionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(averageLabel.snp.bottom)
        }

        let dividerView = UIView()
        view.addSubview(dividerView)
        dividerView.backgroundColor = UIConstants.colors.disabledGreen

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(345)
            make.centerX.equalToSuperview()
            make.top.equalTo(captionLabel.snp.bottom).offset(30)
        }

        // MARK: Table View
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UIConstants.layout.tableViewHeight
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(dividerView.snp.bottom)
            make.bottom.equalTo(leafButton.snp.top).inset(-10)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setUpBottomButtons() {
        // MARK: Leaf Button
        leafButton.setImage(#imageLiteral(resourceName: "leafNotInUse") , for: .normal)
        leafButton.isEnabled = true
        view.addSubview(leafButton)

        leafButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview().priority(.required)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(UIConstants.layout.leafBottomOffset).priority(.medium)
            make.centerX.equalToSuperview()
        }
        leafButton.addTarget(self, action: #selector(displayServings), for: .touchUpInside)

        // MARK: Calendar Button
        calendarButton.setImage(#imageLiteral(resourceName: "calendarInUse") , for: .normal)
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
        navigationController?.pushViewController(SettingsViewController(), animated: false)
    }

}

extension AverageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let servingType = appDelegate.servingsManager.allServingTypes[indexPath.row]
        let manager = appDelegate.servingsManager
        let cell = ServingsTableViewCell(style: .default, reuseIdentifier: "ServingCell", numSections: manager.getMaxServings(for: servingType.key), numFilled: Int16(manager.getAverageServings(for: servingType.key)))
        cell.titleLabel.text = servingType.title
        cell.selectionStyle = .none
        return cell
    }
}
