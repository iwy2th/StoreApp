//
//  ViewController.swift
//  StoreSearch
//
//  Created by Iwy2th on 28/06/2023.
//

import UIKit

class SearchViewController: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  var delegate : UISearchBarDelegate!
  // Keep track of whether a search has been done yet or not
  var hasSearched = false
  // Data Model
  var searchResults = [SearchResult]()
  // MARK: - View Did Load
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    // Register nib
    var cellNib = UINib(nibName: CellIdentifiers.searchResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: CellIdentifiers.searchResultCell)
    cellNib = UINib(nibName: CellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: CellIdentifiers.nothingFoundCell)
  }
}
// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    let searchResult = SearchResult()
    if searchBar.text! != "Justin" {
      for i in 0...2 {
        searchResult.name = String(format: "Fake Result %d ", i)
        searchResult.artistName = searchBar.text!
        searchResults.append(searchResult)
      }
    }
    hasSearched = true
    tableView.reloadData()
  }
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}
// MARK: - Table View Delegate & Data Source
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if searchResults.count == 0 {
      return tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.nothingFoundCell, for: indexPath)
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
      let searchResult = searchResults[indexPath.row]
      cell.nameLabel.text = searchResult.name
      cell.artistNameLabel.text = searchResult.artistName
      return cell
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if searchResults.count == 0 {
      return nil
    } else {
      return indexPath
    }
  }
}
