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
    
    var searchResults = [SearchResult]()
    
    var hasSearched = false
    var isLoading = false

    
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
    
    
    func iTunesURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200", encodedText)
        let url = URL(string: urlString)
        
        return url!
    }
    
    
    func performStoreRequst(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            showNetworkError()
            return nil
        }
    }
    
    
    func parse(data: Data) -> [SearchResult] {
        do {
            let decode = JSONDecoder()
            let result = try decode.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Whoops...",
            message: "There was an error accessing the iTunes Store" + "Please try again",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

//MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            isLoading = true
            tableView.reloadData()
            
            hasSearched = true
            searchResults = []
            
            let queue = DispatchQueue.global()
            let url = self.iTunesURL(searchText: searchBar.text!)

            queue.async {
                if let data = self.performStoreRequst(with: url) {
                    self.searchResults = self.parse(data: data)
                    self.searchResults.sorted(by: <)
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.reloadData()
                    }
                    return
                }
            }
        }
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
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            
            let sniper =  cell.viewWithTag(1000) as! UIActivityIndicatorView
            sniper.startAnimating()
            return cell
        } else {
            if searchResults.count == 0 {
                return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
            } else {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TableView.CellIdentifiers.searchResultCell,
                    for: indexPath) as! SearchResultCell
                
                let searchResult = searchResults[indexPath.row]
                cell.nameLabel.text = searchResult.name
                if searchResult.artist.isEmpty {
                    cell.artistNameLabel.text = "Unknown"
                } else {
                    cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artist, searchResult.type)
                }
                
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
}
