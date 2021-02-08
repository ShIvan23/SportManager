//
//  MainViewController.swift
//  SportManager
//
//  Created by Ivan on 27.01.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Public Properties
    var dataManager: CoreDataManager!
    
    // MARK: - Private Properties
    private var playerArray = [Player]()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubview(tableView)
        title = "Players"
        
        let addPlayerBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(pressedAddPlayer))
        
        navigationItem.rightBarButtonItem = addPlayerBarButtonItem
    }
    
    @objc private func pressedAddPlayer() {
        let viewController = PlayerViewController()
        viewController.dataManager = dataManager
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func fetchData() {
        playerArray = dataManager.fetchData(for: Player.self)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            dataManager.delete(object: playerArray[indexPath.row])
            tableView.performBatchUpdates {
                fetchData()
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } completion: { _ in }

        default:
            break
        }
    }
}
