//
//  MainViewController.swift
//  SportManager
//
//  Created by Ivan on 27.01.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Private Properties
    private let playerArray = [1, 2, 3]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlayerCell.self, forCellReuseIdentifier: PlayerCell.identifierCell)
        return tableView
    }()
    
    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubview(tableView)
        
        let addPlayerBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(pressedAddPlayer))
        
        navigationItem.rightBarButtonItem = addPlayerBarButtonItem
    }
    
    @objc private func pressedAddPlayer() {
        print("Pressed add player")
    }
    
}

// MARK: - Table View Data Source
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.identifierCell, for: indexPath) as! PlayerCell
        let item = playerArray[indexPath.row]
        cell.createCell(item)
        
        return cell
    }
    
    
}

// MARK: - Table View Delegate
extension MainViewController: UITableViewDelegate {
    
}
