//
//  AddAlarmViewController.swift
//  BitAlarm
//
//  Created by Bojan Stefanovic on 12/16/17.
//  Copyright © 2017 Stefanovic Ventures. All rights reserved.
//

import UIKit

private struct Constants {
    static let cellHeight: CGFloat = 44
    private init() {}
}

final class AddAlarmViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var conditionalControl: ConditionalControl!
    @IBOutlet fileprivate weak var dollarValueTextField: UITextField!
    fileprivate let presenter: AddAlarmPresentable
    fileprivate let cellIdentifier = String(describing: CryptocoinCell.self)
    fileprivate let currencyFormatter = CurrencyFormatter()
    fileprivate var cryptocoins = [Cryptocoin]()

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(presenter: AddAlarmPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavbar()
        setupTableView()
        setupTextField()
        populateTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension AddAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}

extension AddAlarmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptocoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? CryptocoinCell else { fatalError("CryptocoinCell was not dequeued") }
        cell.setup(cryptocoins[indexPath.row])
        return cell
    }
}

extension AddAlarmViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = textField.text?
            .replacingOccurrences(of: currencyFormatter.currencySymbol, with: "")
            .replacingOccurrences(of: currencyFormatter.groupingSeparator, with: "")
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = currencyFormatter.formattedText(from: dollarValueTextField.text ?? "0")
    }
}

fileprivate extension AddAlarmViewController {
    @objc func save() {
        let indexPath = tableView.indexPathForSelectedRow ?? IndexPath(row: 0, section: 0)
        let cryptocoin = (tableView.cellForRow(at: indexPath) as? CryptocoinCell)?.cryptocoin ?? presenter.bitcoin
        let value = currencyFormatter.formattedText(from: dollarValueTextField.text ?? "0")
        let alarm = Alarm(isOn: true, cryptocoin: cryptocoin, condition: conditionalControl.condition, value: value)

        do {
            try presenter.saveAlarm(alarm)
            dismissKeyboardAndController()
        } catch {
            print(#function, error)
        }
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

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }

    func populateTableView() {
        do {
            cryptocoins = try presenter.getCryptocoins()
            tableView.reloadData()
        } catch {
            print(#function, error)
        }
    }

    func setupTextField() {
        let height = dollarValueTextField.frame.height
        let frame = CGRect(x: 0, y: 0, width: height * 2, height: height)

        let symbolLabel = newLabel(frame: frame, text: presenter.currencySymbol)
        dollarValueTextField.leftViewMode = .always
        dollarValueTextField.leftView = symbolLabel

        let currencyLabel = newLabel(frame: frame, text: presenter.currencyCode)
        dollarValueTextField.rightViewMode = .always
        dollarValueTextField.rightView = currencyLabel

        dollarValueTextField.keyboardType = .decimalPad
        dollarValueTextField.delegate = self
    }

    func newLabel(frame: CGRect, text: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = text
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        return label
    }
}

fileprivate extension Selector {
    static let save = #selector(AddAlarmViewController.save)
    static let cancel = #selector(AddAlarmViewController.cancel)
}
