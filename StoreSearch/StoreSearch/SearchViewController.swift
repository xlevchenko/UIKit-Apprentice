//
//  ViewController.swift
//  StoreSearch
//
//  Created by Olexsii Levchenko on 8/29/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var search = Search()
    
    var landscapeVC: LandscapeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        
        cellNib = (UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil))
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        
        searchBar.resignFirstResponder()
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        switch newCollection.verticalSizeClass {
        case .compact:
            showLandscape(with: coordinator)
        case .regular, .unspecified:
            hideLandscape(with: coordinator)
        @unknown default:
            break
        }
    }
    
    func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        guard landscapeVC == nil else { return }
        
        landscapeVC = storyboard!.instantiateViewController(withIdentifier: "LandscapeViewController") as? LandscapeViewController
        if let controller = landscapeVC {
            controller.search = search
            controller.view.frame = view.bounds
            controller.view.alpha = 0
            
            view.addSubview(controller.view)
            addChild(controller)
            
            coordinator.animate { _ in
                controller.view.alpha = 1
                self.searchBar.resignFirstResponder()
            } completion: { _ in
                controller.didMove(toParent: self)
            }
            
            if self.presentedViewController != nil {
                self.dismiss(animated: true)
            }
        }
    }
    
    
    func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        if let controller = landscapeVC {
            controller.willMove(toParent: nil)
            
            coordinator.animate { _ in
                controller.view.alpha = 0
                if self.presentationController != nil {
                    self.dismiss(animated: true)
                }
            } completion: { _ in
                controller.view.removeFromSuperview()
                controller.removeFromParent()
                self.landscapeVC = nil
            }
        }
    }
    
    
    func showNetworkError() {
        let alert = UIAlertController(
            title: NSLocalizedString("Whoops...", comment: "Error alert: title"),
            message: NSLocalizedString("There was an error accessing the iTunes Store. Please try again", comment: "Error alert: massage"),
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    func performSearch() {
        if let category =  Search.Category(rawValue: segmentedControl.selectedSegmentIndex) {
            search.performSearch(for: searchBar.text!, category: category) { success in
                if !success {
                    self.showNetworkError()
                }
                self.tableView.reloadData()
                self.landscapeVC?.searchResultReceived()
            }
        }
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    
    
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        performSearch()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if case .result(let list) = search.state {
                segue.destination.modalPresentationStyle = .overFullScreen
                let detailViewController = segue.destination as! DetailViewController
                let indexPath = sender as! IndexPath
                let searchResult = list[indexPath.row]
                detailViewController.searchResult = searchResult
            }
        }
    }
}


//MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}


//MARK: - Constant Identifiers
extension SearchViewController {
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
}


//MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch search.state {
        case .notSearchedYet:
            return 0
        case .loading:
            return 1
        case .noResult:
            return 1
        case .result(let list):
            return list.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch search.state {
        case .notSearchedYet:
            fatalError("Should never get here.")
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            let sniper =  cell.viewWithTag(1000) as! UIActivityIndicatorView
            sniper.startAnimating()
            return cell
        case .noResult:
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        case .result(let list):
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            
            let searchResult = list[indexPath.row]
            cell.configure(for: searchResult)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch search.state {
        case .notSearchedYet, .loading, .noResult:
            return nil
        case .result:
            return indexPath
        }
    }
}
