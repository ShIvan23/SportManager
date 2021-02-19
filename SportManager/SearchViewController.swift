//
//  SearchViewController.swift
//  SportManager
//
//  Created by Ivan on 13.02.2021.
//

import UIKit

// MARK: - Protocol
protocol SearchDelegate: class {
    func viewController(_ viewController: SearchViewController, predicate: NSCompoundPredicate)
}

class SearchViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: SearchDelegate?
    
    // MARK: - Private Properties
    private let positions = ["Вратарь", "Нападающий", "Полузащитник", "Защитник"]
    private let teams = ["Спартак", "Зенит", "ЦСКА", "Краснодар", "Локомотив"]
    private var selectedTeam = ""
    private var selectedPosition = ""
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let roundedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name contains"
        textField.textContentType = .name
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }()
    
    private lazy var ageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Age"
        textField.textContentType = .name
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }()
    
    private let ageSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.insertSegment(withTitle: ">=", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "=", at: 1, animated: true)
        segmentControl.insertSegment(withTitle: "<=", at: 2, animated: true)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = .systemBlue
        return segmentControl
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Position:"
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let teamLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Team:"
        return label
    }()
    
    private let selectPositionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(selectPositionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let selectTeamButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(selectTeamButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var teamPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var positionPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private let startSearchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Search", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(startSearchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLayout()
    }
    
    // MARK: - Override Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !positionPickerView.isHidden {
            positionPickerView.isHidden = true
            showLabelsAndButtons()
        }
        
        if !teamPickerView.isHidden {
            teamPickerView.isHidden = true
            showLabelsAndButtons()
        }
    }
    
    // MARK: - Private Methods
    @objc private func startSearchButtonPressed() {
        let compoundPredicate = makeCompoundPredicate(name: nameTextField.text!, age: ageTextField.text!, position: selectedPosition, team: selectedTeam)
        delegate?.viewController(self, predicate: compoundPredicate)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func resetButtonPressed() {
        let emptyPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [])
        delegate?.viewController(self, predicate: emptyPredicate)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func selectPositionButtonPressed() {
        positionPickerView.isHidden = false
        hideLabelsAndButtons()
    }
    
    @objc private func selectTeamButtonPressed() {
        teamPickerView.isHidden = false
        hideLabelsAndButtons()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
    }
    
    private func hideLabelsAndButtons() {
        positionLabel.isHidden = true
        selectPositionButton.isHidden = true
        teamLabel.isHidden = true
        selectTeamButton.isHidden = true
        startSearchButton.isHidden = true
        resetButton.isHidden = true
    }
    
    private func showLabelsAndButtons() {
        positionLabel.isHidden = false
        selectPositionButton.isHidden = false
        teamLabel.isHidden = false
        selectTeamButton.isHidden = false
        startSearchButton.isHidden = false
        resetButton.isHidden = false
    }
    
    private func makeCompoundPredicate(name: String, age: String, position: String, team: String) -> NSCompoundPredicate {
        
        var predicates = [NSPredicate]()
        
        if !name.isEmpty {
            let namePredicate = NSPredicate(format: "fullName CONTAINS[cd] '\(name)'")
            predicates.append(namePredicate)
        }
        
        if !age.isEmpty {
            let selectedSegmentControl = ageSearchCondition(index: ageSegmentControl.selectedSegmentIndex)
            let agePredicate = NSPredicate(format: "age \(selectedSegmentControl) '\(age)'")
            predicates.append(agePredicate)
        }
        
        if !position.isEmpty {
            let positionPredicate = NSPredicate(format: "position CONTAINS[cd] '\(position)'")
            predicates.append(positionPredicate)
        }
        
        if !team.isEmpty {
            let teamPredicate = NSPredicate(format: "club.name CONTAINS[cd] '\(team)'")
            predicates.append(teamPredicate)
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    private func ageSearchCondition(index: Int) -> String {
        
        var condition: String!
        
        switch index {
        case 0: condition = ">="
        case 1: condition = "="
        case 2: condition = "<="
        default: break
        }
        
        return condition
    }
    
    private func setupLayout() {
        [mainView, roundedView].forEach { (element) in
            view.addSubview(element)
        }
        
        [nameTextField, ageTextField, ageSegmentControl, positionLabel, selectPositionButton, teamLabel, selectTeamButton, startSearchButton, resetButton, teamPickerView, positionPickerView].forEach { (element) in
            roundedView.addSubview(element)
        }
        
        let inset: CGFloat = 15
        let roundedViewWidth = UIScreen.main.bounds.width / 3 * 2
        let ageTextFieldWidth = roundedViewWidth / 5 * 3 - inset * 2
        
        NSLayoutConstraint.activate([mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
                                     roundedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     roundedView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     roundedView.heightAnchor.constraint(equalToConstant: 350),
                                     roundedView.widthAnchor.constraint(equalToConstant: roundedViewWidth),
        
                                     nameTextField.topAnchor.constraint(equalTo: roundedView.topAnchor, constant: inset),
                                     nameTextField.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor, constant: inset),
                                     nameTextField.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor, constant: -inset),
        
                                     ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: inset),
                                     ageTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                                     ageTextField.widthAnchor.constraint(equalToConstant: ageTextFieldWidth),
        
                                     ageSegmentControl.topAnchor.constraint(equalTo: ageTextField.topAnchor),
                                     ageSegmentControl.leadingAnchor.constraint(equalTo: ageTextField.trailingAnchor, constant: 5),
                                     ageSegmentControl.bottomAnchor.constraint(equalTo: ageTextField.bottomAnchor),
                                     ageSegmentControl.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                                     
                                     positionLabel.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 30),
                                     positionLabel.leadingAnchor.constraint(equalTo: ageTextField.leadingAnchor),
                                     
                                     selectPositionButton.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 15),
                                     selectPositionButton.centerYAnchor.constraint(equalTo: positionLabel.centerYAnchor),
                                     
                                     teamLabel.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 30),
                                     teamLabel.leadingAnchor.constraint(equalTo: positionLabel.leadingAnchor),
                                     
                                     selectTeamButton.leadingAnchor.constraint(equalTo: teamLabel.trailingAnchor, constant: 15),
                                     selectTeamButton.centerYAnchor.constraint(equalTo: teamLabel.centerYAnchor),
                                     
                                     resetButton.centerXAnchor.constraint(equalTo: roundedView.centerXAnchor),
                                     resetButton.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor, constant: -inset),
                                     
                                     startSearchButton.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -inset),
                                     startSearchButton.centerXAnchor.constraint(equalTo: resetButton.centerXAnchor),
                                     
                                     teamPickerView.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: inset),
                                     teamPickerView.centerXAnchor.constraint(equalTo: roundedView.centerXAnchor),
                                     
                                     positionPickerView.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: inset),
                                     positionPickerView.centerXAnchor.constraint(equalTo: roundedView.centerXAnchor)
        ])
    }
    

}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case nameTextField:
            ageTextField.becomeFirstResponder()
        default:
            view.endEditing(true)
        }
        return true
    }
}

extension SearchViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == teamPickerView {
            let team = teams[row]
            selectTeamButton.setTitle(team, for: .normal)
            selectedTeam = team
            teamPickerView.isHidden = true
            showLabelsAndButtons()
        } else if pickerView == positionPickerView {
            let position = positions[row]
            selectPositionButton.setTitle(position, for: .normal)
            selectedPosition = position
            positionPickerView.isHidden = true
            showLabelsAndButtons()
        }
    }
}

extension SearchViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var count = 0
        if pickerView == teamPickerView {
            count = teams.count
        } else if pickerView == positionPickerView {
            count = positions.count
        }
        
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title = ""
        if pickerView == teamPickerView {
            title = teams[row]
        } else if pickerView == positionPickerView {
            title = positions[row]
        }
        
        return title
    }
    
    
}
