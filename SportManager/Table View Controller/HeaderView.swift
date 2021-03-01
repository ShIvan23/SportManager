//
//  HeaderView.swift
//  SportManager
//
//  Created by Ivan on 09.02.2021.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    static let headerIdentifier = "HeaderView"

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
