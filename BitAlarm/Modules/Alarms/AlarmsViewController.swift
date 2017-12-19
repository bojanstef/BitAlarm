//
//  AlarmsViewController.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/15/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let cellHeight: CGFloat = 96
    private init() {}
}

final class AlarmsViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate let presenter: AlarmsPresentable
    fileprivate let cellIdentifier = String(describing: AlarmCell.self)
    fileprivate var alarms = [Alarm]()

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(presenter: AlarmsPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavbar()
        setupTableView()
        populateTableView()
    }
}

extension AlarmsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}

extension AlarmsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? AlarmCell else { fatalError("AlarmCell was not dequeued") }
        cell.setup(alarms[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            alarms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

fileprivate extension AlarmsViewController {
    @objc func addAlarm() {
        presenter.showAddAlarmController()
    }

    func setupNavbar() {
        navigationItem.title = presenter.navbarTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .addAlarm)
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }

    func populateTableView() {
        do {
            alarms = try presenter.getAlarms()
            tableView.reloadData()
        } catch {
            print(#function, error)
        }
    }
}

fileprivate extension Selector {
    static let addAlarm = #selector(AlarmsViewController.addAlarm)
}
