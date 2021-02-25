//
//  MainViewController.swift
//  SportManager
//
//  Created by Ivan on 27.01.2021.
//

import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    // MARK: - Public Properties
    var dataManager: CoreDataManager!
    var fetchedResultController: NSFetchedResultsController<Player>!
    
    // MARK: - Private Properties
    private var playerArray = [Player]()
    private var selectedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [])
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlayerCell.self, forCellReuseIdentifier: PlayerCell.identifierCell)
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.headerIdentifier)
        return tableView
    }()
    
    private let playerStatusSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.insertSegment(withTitle: "All", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "In Play", at: 1, animated: true)
        segmentControl.insertSegment(withTitle: "Bench", at: 2, animated: true)
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(playerStatusSegmentControlPressed), for: .valueChanged)
        return segmentControl
    }()
    
    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData(predicate: selectedPredicate)
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "Players"
        view.backgroundColor = .systemBackground
        
        let addPlayerBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressedAddPlayer))
        let searchPlayerBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(pressedSearchPlayer))
        
        navigationItem.rightBarButtonItem = addPlayerBarButtonItem
        navigationItem.leftBarButtonItem = searchPlayerBarButtonItem
    }
    
    private func setupLayout() {
        [tableView, playerStatusSegmentControl].forEach { (element) in
            view.addSubview(element)
        }
        
        let inset: CGFloat = 15
        
        NSLayoutConstraint.activate([playerStatusSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
                                     playerStatusSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
                                     playerStatusSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
                                     playerStatusSegmentControl.heightAnchor.constraint(equalToConstant: 30),
                                        
                                        tableView.topAnchor.constraint(equalTo: playerStatusSegmentControl.bottomAnchor, constant: inset),
                                     tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    @objc private func playerStatusSegmentControlPressed() {
        playerArray.removeAll()
        fetchData(predicate: selectedPredicate)
        tableView.reloadData()
    }
    
    @objc private func pressedAddPlayer() {
        let viewController = PlayerViewController()
        viewController.dataManager = dataManager
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func pressedSearchPlayer() {
        let searchViewController = SearchViewController()
        searchViewController.delegate = self
        searchViewController.modalTransitionStyle = .crossDissolve
        searchViewController.modalPresentationStyle = .overCurrentContext
        present(searchViewController, animated: true, completion: nil)
    }
    
    private func fetchData(predicate: NSCompoundPredicate? = nil) {
        
        fetchedResultController = dataManager.fetchData(for: Player.self, sectionNameKeyPath: "position", predicate: predicate)
        fetchedResultController.delegate = self
    
//         let fetchedAllPlayers = dataManager.fetchData(for: Player.self, predicate: predicate)
//
//        switch playerStatusSegmentControl.selectedSegmentIndex {
//
//        case 0:
//            playerArray = fetchedAllPlayers
//
//        case 1:
//            guard let playersInPlay = fetchedAllPlayers.first?.value(forKey: "inPlayProperty") as? [Player] else { return }
//            playerArray = fetchedAllPlayers.filter { playersInPlay.contains($0) }
//
//        case 2:
//            guard let benchPlayers = fetchedAllPlayers.first?.value(forKey: "benchProperty") as? [Player] else { return }
//            playerArray = fetchedAllPlayers.filter { benchPlayers.contains($0) }
//
//        default: break
//        }
    }
    
}

// MARK: - Table View Data Source
extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let sections = fetchedResultController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = fetchedResultController.sections else { return nil }
        return sections[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchedResultController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.identifierCell, for: indexPath) as! PlayerCell
        let item = fetchedResultController.object(at: indexPath)
        cell.createCell(item)
        
        return cell
    }
}

// MARK: - NSFetchedResultControllerDelegate
extension MainViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
            
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! PlayerCell
                let player = fetchedResultController.object(at: indexPath as IndexPath)
                cell.createCell(player)
            }
            
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
            let player = fetchedResultController.object(at: indexPath)
            dataManager.delete(object: player)
//            tableView.performBatchUpdates {
//                fetchData()
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                
//            } completion: { _ in }

        default:
            break
        }
    }
}

extension MainViewController: SearchDelegate {
    func viewController(_ viewController: SearchViewController, predicate: NSCompoundPredicate) {
        fetchData(predicate: predicate)
        selectedPredicate = predicate
        tableView.reloadData()
    }
}
