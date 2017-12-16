//
//  AddAlarmViewController.swift
//  CryptoAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

final class AddAlarmViewController: UIViewController {
    fileprivate let presenter: AddAlarmPresentable

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(presenter: AddAlarmPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavbar()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

fileprivate extension AddAlarmViewController {
    @objc func save() {
        print(#function, "cache Alarm To Disk")
        dismissKeyboardAndController()
    }

    @objc func cancel() {
        dismissKeyboardAndController()
    }

    func setupNavbar() {
        navigationItem.title = presenter.navbarTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: .save)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: .cancel)
    }

    func dismissKeyboardAndController() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

fileprivate extension Selector {
    static let save = #selector(AddAlarmViewController.save)
    static let cancel = #selector(AddAlarmViewController.cancel)
}
