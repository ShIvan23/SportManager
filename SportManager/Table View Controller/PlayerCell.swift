//
//  PlayerCell.swift
//  SportManager
//
//  Created by Ivan on 27.01.2021.
//

import UIKit

final class PlayerCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let identifierCell = "PlayerCell"
    
    // MARK: - Private Properties
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.2714112997, green: 0.6117960811, blue: 0.5859911442, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray5
        imageView.image = #imageLiteral(resourceName: "Generic-avatar")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemGray6
        return stackView
    }()
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let teamLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Team"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let nationalityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nationality"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Position"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Age"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let teamDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nationalityDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let positionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func createCell(_ model: Player) {
        numberLabel.text = "\(model.number)"
        fullNameLabel.text = model.fullName
        avatarImageView.image = UIImage(data: model.image ?? Data())
        teamDescriptionLabel.text = model.team
        nationalityDescriptionLabel.text = model.nationality
        positionDescriptionLabel.text = model.position
        ageDescriptionLabel.text = "\(model.age)"
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        [numberLabel, fullNameLabel, avatarImageView, mainStackView, leftStackView, teamLabel, nationalityLabel, positionLabel, ageLabel, rightStackView, teamDescriptionLabel, nationalityDescriptionLabel, positionDescriptionLabel, ageDescriptionLabel].forEach { (element) in
            addSubview(element)
        }
        
        let inset: CGFloat = 10
        let imageSize: CGFloat = 125
        let halfMainStackViewWidth = (frame.width - (inset * 3)) / 2.5
        
        NSLayoutConstraint.activate([numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
                                     numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
                                     numberLabel.widthAnchor.constraint(equalToConstant: 25),
                                     numberLabel.heightAnchor.constraint(equalToConstant: 25),
                                     
                                     fullNameLabel.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
                                     fullNameLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: inset),
                                     
                                     avatarImageView.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: inset),
                                     avatarImageView.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
                                     avatarImageView.heightAnchor.constraint(equalToConstant: imageSize),
                                     avatarImageView.widthAnchor.constraint(equalToConstant: imageSize),
                                     
                                     mainStackView.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
                                     mainStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: inset),
                                     mainStackView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
                                     mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
                                     
                                     leftStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
                                     leftStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
                                     leftStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
                                     leftStackView.widthAnchor.constraint(equalToConstant: halfMainStackViewWidth),
                                     
                                     teamLabel.topAnchor.constraint(equalTo: leftStackView.topAnchor, constant: inset),
                                     teamLabel.leadingAnchor.constraint(equalTo: leftStackView.leadingAnchor, constant: inset),
                                     
                                     nationalityLabel.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: inset),
                                     nationalityLabel.leadingAnchor.constraint(equalTo: teamLabel.leadingAnchor),
                                     
                                     positionLabel.topAnchor.constraint(equalTo: nationalityLabel.bottomAnchor, constant: inset),
                                     positionLabel.leadingAnchor.constraint(equalTo: nationalityLabel.leadingAnchor),
                                     
                                     ageLabel.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: inset),
                                     ageLabel.leadingAnchor.constraint(equalTo: positionLabel.leadingAnchor),
                                     
                                     rightStackView.topAnchor.constraint(equalTo: leftStackView.topAnchor),
                                     rightStackView.leadingAnchor.constraint(equalTo: leftStackView.trailingAnchor),
                                     rightStackView.bottomAnchor.constraint(equalTo: leftStackView.bottomAnchor),
                                     rightStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
                                     
                                     teamDescriptionLabel.topAnchor.constraint(equalTo: teamLabel.topAnchor),
                                     teamDescriptionLabel.leadingAnchor.constraint(equalTo: rightStackView.leadingAnchor),
                                     
                                     nationalityDescriptionLabel.topAnchor.constraint(equalTo: nationalityLabel.topAnchor),
                                     nationalityDescriptionLabel.leadingAnchor.constraint(equalTo: teamDescriptionLabel.leadingAnchor),
                                     
                                     positionDescriptionLabel.topAnchor.constraint(equalTo: positionLabel.topAnchor),
                                     positionDescriptionLabel.leadingAnchor.constraint(equalTo: teamDescriptionLabel.leadingAnchor),
                                     
                                     ageDescriptionLabel.topAnchor.constraint(equalTo: ageLabel.topAnchor),
                                     ageDescriptionLabel.leadingAnchor.constraint(equalTo: teamDescriptionLabel.leadingAnchor)])
    }
    
}
