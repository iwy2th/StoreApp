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
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  var delegate : UISearchBarDelegate!
  // Keep track of whether a search has been done yet or not
  var hasSearched = false
  // downloading stuff
  var isLoading = false
  // Data Model
  var searchResults = [SearchResult]()
  // data task
  var dataTask: URLSessionDataTask?
  // MARK: - View Did Load
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    // Register nib
    var cellNib = UINib(nibName: CellIdentifiers.searchResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: CellIdentifiers.searchResultCell)
    cellNib = UINib(nibName: CellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: CellIdentifiers.nothingFoundCell)
    cellNib = UINib(nibName: CellIdentifiers.loadingCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: CellIdentifiers.loadingCell)
    // show keyboard on launch
    searchBar.becomeFirstResponder()
  }
  @IBAction func segmentChanged(_ sender: UISearchBar) {
    performSearch()
  }

}
// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearch()
  }
  func performSearch() {
    if !searchBar.text!.isEmpty {
      searchBar.resignFirstResponder()
      isLoading = true
      dataTask?.cancel()
      tableView.reloadData()
      hasSearched = true
      searchResults = []
      let url = iTunesURL(searchText: searchBar.text!, category: segmentedControl.selectedSegmentIndex)
      //2
      let session = URLSession.shared
      //3
      dataTask = session.dataTask(with: url) { data, response, error in
      //4
        if let error = error as NSError?, error.code == -999 {
          print("Failure \(error.localizedDescription)")
          return
        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
          if let data {
            print("On main thread? " + (Thread.current.isMainThread ? "Yes" : "No"))
            self.searchResults = self.parse(data: data)
            self.searchResults.sort(by: <)
            DispatchQueue.main.async {
              self.isLoading = false
              self.tableView.reloadData()
            }
            return
          }
        } else {
          print("Failure! \(response!)")
        }
        DispatchQueue.main.async {
          self.hasSearched = false
          self.isLoading = false
          self.tableView.reloadData()
          self.showNetworkError()
        }
      }
      // 5
      dataTask?.resume()
      }
    }
    func position(for bar: UIBarPositioning) -> UIBarPosition {
      return .topAttached
    }
    // MARK: - URL for the request
  func iTunesURL(searchText: String, category: Int) -> URL {
    let kind: String
    switch category {
    case 1: kind = "musicTrack"
    case 2: kind = "software"
    case 3: kind = "ebook"
    default: kind = ""
    }
      let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
      let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200&entity=\(kind)", encodedText)
      let url = URL(string: urlString)
      return url!
    }

    // MARK: - Parse JSON
    func parse(data: Data) -> [SearchResult] {
      do  {
        let decoder = JSONDecoder()
        let result = try decoder.decode(ResultArray.self, from: data)
        return result.results
      } catch {
        print("JSON Error: \(error)")
        return []
      }
    }
    // MARK: - Error handling
    func showNetworkError() {
      let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store" + "Please try again.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
    }

  }
  // MARK: - Table View Delegate & Data Source
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.loadingCell, for: indexPath)
        let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
        spinner.startAnimating()
        return cell
      } else if searchResults.count == 0 {
        return tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.nothingFoundCell, for: indexPath)
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
        let searchResult = searchResults[indexPath.row]
        cell.configure(for: searchResult)
        return cell
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
  // MARK: - Operator overloading
  func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
  }
