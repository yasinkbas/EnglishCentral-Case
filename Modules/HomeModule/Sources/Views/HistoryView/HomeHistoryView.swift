//
//  HomeHistoryView.swift
//  HomeModule
//
//  Created by Yasin Akbas on 21.07.2022.
//  Copyright © 2022 com.yasinkbas.HomeModule. All rights reserved.
//

import UIKit
import CommonKit

protocol HomeHistoryViewInterface: AnyObject {
    var viewHeight: Double { get }
    
    func prepareUI()
    func reloadTableView()
}

private extension HomeHistoryView {
    enum Constant {
        static let backgroundColor: UIColor = Colors.darkGray
        static let cornerRadius: Double = 16
        static let cellTextFontSize: Double = 18
    }
}

final class HomeHistoryView: UIView {
    var presenter: HomeHistoryPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Constant.backgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        return tableView
    }()
}

// MARK: - HomeHistoryViewInterface
extension HomeHistoryView: HomeHistoryViewInterface {
    var viewHeight: Double { presenter.calculatedHeight }
    
    func prepareUI() {
        addSubview(tableView)
        tableView.set(.leadingOf(self), .topOf(self), .trailingOf(self), .bottomOf(self))
        
        clipsToBounds = true
        layer.cornerRadius = Constant.cornerRadius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension HomeHistoryView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.tableViewNumberOfSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter.tableViewHeightForRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = presenter.cellTitleFor(index: indexPath.row)
        cell.textLabel?.font = UIFont.systemFont(ofSize: Constant.cellTextFontSize)
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = Constant.backgroundColor
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeHistoryView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(index: indexPath.row)
    }
}
