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
    private let nameLabel: UILabel = {
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
    func createCell(_ model: Int) {
        nameLabel.text = "\(model)"
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
                                     nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
                                     nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
                                     nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)])
    }
    
}
