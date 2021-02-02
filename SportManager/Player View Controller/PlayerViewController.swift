//
//  PlayerViewController.swift
//  SportManager
//
//  Created by Ivan on 30.01.2021.
//

import UIKit
import CoreData

final class PlayerViewController: UIViewController {
    
    // MARK: - Public Properties
    var dataManager: CoreDataManager!
    
    // MARK: - Private Properties
    private var chosenImage = #imageLiteral(resourceName: "Generic-avatar")
    private var selectedClub: String!
    private var selectedPosition: String!
    private var imagePickerController = UIImagePickerController()
    private let positions = ["Вратарь", "Нападающий", "Полузащитник", "Защитник"]
    private let teams = ["Спартак", "Зенит", "ЦСКА", "Краснодар", "Локомотив"]
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .purple
        imageView.image = chosenImage
        return imageView
    }()
    
    private let uploadImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Upload image", for: .normal)
        button.addTarget(self, action: #selector(uploadImageButtonPressed), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name"
        textField.textContentType = .name
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(inputText), for: .editingChanged)
        return textField
    }()
    
    private lazy var nationalityTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Nationality"
        textField.textContentType = .name
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(inputText), for: .editingChanged)
        return textField
    }()
    
    private lazy var numberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Number"
        textField.textContentType = .telephoneNumber
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(inputText), for: .editingChanged)
        return textField
    }()
    
    private lazy var ageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Age"
        textField.textContentType = .telephoneNumber
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(inputText), for: .editingChanged)
        return textField
    }()
    
    private let teamLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Team:"
        return label
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Position:"
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.isEnabled = false
        button.alpha = 0.3
        return button
    }()
    
    private let selectTeamButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Press to select", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(selectTeamButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let selectPositionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Press to select", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(selectPositionButtonPressed), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupImagePickerController()
    }
    
    // MARK: - Private Methods
    @objc private func uploadImageButtonPressed() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func inputText() {
        guard let name = nameTextField.text,
              let number = numberTextField.text,
              let nationality = nationalityTextField.text,
              let age = ageTextField.text else { return }
        
        saveButton.isEnabled = !name.isEmpty && !number.isEmpty && !nationality.isEmpty && !age.isEmpty
        saveButton.alpha = saveButton.isEnabled ? 1 : 0.3
    }
    
    @objc private func saveButtonPressed() {
        let context = dataManager.getContext()
        
        let club = dataManager.createObject(from: Club.self)
        club.name = selectedClub
        
        let player = dataManager.createObject(from: Player.self)
        player.fullName = nameTextField.text
        player.number = Int16((numberTextField.text! as NSString).integerValue)
        player.team = selectedClub
        player.image = chosenImage.pngData()
        player.nationality = nationalityTextField.text
        player.position = selectedPosition
        player.age = Int16((ageTextField.text! as NSString).integerValue)
        
        dataManager.save(context: context)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectTeamButtonPressed() {
        teamPickerView.isHidden = false
        hideTeamAndPosition()
    }
    
    @objc private func selectPositionButtonPressed() {
        positionPickerView.isHidden = false
        hideTeamAndPosition()
    }
    
    private func setupImagePickerController() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
    }
    
    private func hideTeamAndPosition() {
        teamLabel.isHidden = true
        selectTeamButton.isHidden = true
        positionLabel.isHidden = true
        selectPositionButton.isHidden = true
    }
    
    private func showTeamAndPosition() {
        teamLabel.isHidden = false
        selectTeamButton.isHidden = false
        positionLabel.isHidden = false
        selectPositionButton.isHidden = false
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        [avatarImageView, uploadImageButton, nameTextField, numberTextField, nationalityTextField, ageTextField, teamLabel, positionLabel, saveButton, selectTeamButton, selectPositionButton, teamPickerView, positionPickerView].forEach { (element) in
            view.addSubview(element)
        }
        
        NSLayoutConstraint.activate([avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                                     avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     avatarImageView.heightAnchor.constraint(equalToConstant: 200),
                                     avatarImageView.widthAnchor.constraint(equalToConstant: 200),
                                     
                                     uploadImageButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
                                     uploadImageButton.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
                                     
                                     nameTextField.topAnchor.constraint(equalTo: uploadImageButton.bottomAnchor, constant: 20),
                                     nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                                     
                                     numberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
                                     numberTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                                     numberTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                                     
                                     nationalityTextField.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 10),
                                     nationalityTextField.leadingAnchor.constraint(equalTo: numberTextField.leadingAnchor),
                                     nationalityTextField.trailingAnchor.constraint(equalTo: numberTextField.trailingAnchor),
                                     
                                     ageTextField.topAnchor.constraint(equalTo: nationalityTextField.bottomAnchor, constant: 10),
                                     ageTextField.leadingAnchor.constraint(equalTo: nationalityTextField.leadingAnchor),
                                     ageTextField.trailingAnchor.constraint(equalTo: nationalityTextField.trailingAnchor),
                                     
                                     teamLabel.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 20),
                                     teamLabel.leadingAnchor.constraint(equalTo: ageTextField.leadingAnchor),
                                     teamLabel.heightAnchor.constraint(equalToConstant: 30),
                                     
                                     selectTeamButton.topAnchor.constraint(equalTo: teamLabel.topAnchor),
                                     selectTeamButton.leadingAnchor.constraint(equalTo: teamLabel.trailingAnchor, constant: 10),
                                     selectTeamButton.heightAnchor.constraint(equalToConstant: 30),
                                     
                                     positionLabel.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 20),
                                     positionLabel.leadingAnchor.constraint(equalTo: teamLabel.leadingAnchor),
                                     positionLabel.heightAnchor.constraint(equalToConstant: 30),
                                     
                                     selectPositionButton.topAnchor.constraint(equalTo: positionLabel.topAnchor),
                                     selectPositionButton.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 10),
                                     selectPositionButton.heightAnchor.constraint(equalToConstant: 30),
                                     
                                     saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                                     saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     
                                     teamPickerView.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 10),
                                     teamPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     
                                     positionPickerView.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 10),positionPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
}

// MARK: - Text Field Delegate
extension PlayerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            numberTextField.becomeFirstResponder()
        } else if textField == numberTextField {
            nationalityTextField.becomeFirstResponder()
        } else if textField == nationalityTextField {
            ageTextField.becomeFirstResponder()
        }
        
        return true
    }
}

// MARK: - Image Picker Controller Delegate
extension PlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        chosenImage = image
        avatarImageView.image = chosenImage
        
        imagePickerController.dismiss(animated: true, completion: nil)
        
    }
}

// MARK: - Picker View Delegate
extension PlayerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == teamPickerView {
            let team = teams[row]
            selectTeamButton.setTitle(team, for: .normal)
            selectedClub = team
            teamPickerView.isHidden = true
            showTeamAndPosition()
        } else if pickerView == positionPickerView {
            let position = positions[row]
            selectPositionButton.setTitle(position, for: .normal)
            selectedPosition = position
            positionPickerView.isHidden = true
            showTeamAndPosition()
        }
    }
}

// MARK: - Picker View Data Source
extension PlayerViewController: UIPickerViewDataSource {
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