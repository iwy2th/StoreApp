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
  // keep track of whether a search has been done yet or not
  var hasSearched = false
  // data Model
  var searchResults = [SearchResult]()
  // MARK: - View Did Load
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    let cellIdentifier = "SearchResultCell"
    var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    if cell == nil {
      cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
    } else {
      if searchResults.count == 0 {
        cell?.textLabel!.text = "(Nothing found)"
        cell?.detailTextLabel!.text = ""
      } else {
        let searchResult = searchResults[indexPath.row]
        cell?.textLabel?.text = searchResult.name
        cell?.detailTextLabel?.text = searchResult.artistName
      }
    }

    return cell!
  }
}
