//
//  HomeViewController.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-15.
//

import UIKit
import Combine

class HomeViewController: UIViewController, MyGiphyCellDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var giphyTableView: UITableView!
    var tabBarViewModel: TabBarViewModel = TabBarViewModel()
    var homeViewModel = HomeViewModel()
    var savedFiles: [File] = []
    var searchController = UISearchController(searchResultsController: nil)
    var tableFooterView = TableFooterView()
    var debounceSubscription: AnyCancellable?
    let searchQuerySubject = PassthroughSubject<String, Never>()
    let screenHeight = UIScreen.main.bounds.height
    let placeholderView = PlaceholderView()

    var searchQuery = "" {
        didSet {
            searchQuerySubject.send(searchQuery)
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.updateActivityIndicator = { [weak self] in
            guard let self = self else { return }
            if self.homeViewModel.isActivityIndicatorVisible {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    
        homeViewModel.showErrorMessage = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { [self] in
                self.homeViewModel.isActivityIndicatorVisible = false
                if self.homeViewModel.errorMessage.count > 0 {
                    let alert = UIAlertController(title: nil, message: self.homeViewModel.errorMessage, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        tableFooterView.frame = CGRect(x: 0, y: 0, width: 300, height: screenHeight)
        giphyTableView.clipsToBounds = true
        tabBarViewModel.loadTabBarItems()
        configureSearchController()
        getTrendingGiphy()
        
        /// Debounce effect is used to add lag in keyboard typing to hit api request.
        debounceSubscription = searchQuerySubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main, options: nil)
            .sink { [self]  query in
                if query.isEmpty {
                    homeViewModel.isSearchBarActive = false
                    homeViewModel.searchedGifs.removeAll()
                    refreshData()
                } else {
                    homeViewModel.isSearchBarActive = true
                    getSearchGiphy(query: query, isOffset: false)
                }
            }
        setUpPlaceholderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedFiles = homeViewModel.getGifFilesFromFileManager()
        refreshData()
    }
    
    // MARK: - Setup
    
    func setUpPlaceholderView() {
        view.addSubview(placeholderView)
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderView.topAnchor.constraint(equalTo: view.topAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        placeholderView.isHidden = true
    }
    
    /// Cnfigure search view controller in view
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    /// This method is sed to reload table view data
    func refreshData() {
        giphyTableView.reloadData()
    }

    // MARK: - Get/Search Giphy

    /// This method is use to fertch giphy data from  homeViewModel.
    func getTrendingGiphy() {
        homeViewModel.isActivityIndicatorVisible = true
        homeViewModel.getTrendingResults {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.refreshData()
                self.homeViewModel.isActivityIndicatorVisible = false
                self.tableFooterView.activityIndicator.stopAnimating()
            }
        }
    }
    
    /// This method is use to fertch  searched giphy data from  homeViewModel.
    /// - Parameters:
    /// - Search Text - Get text from search bar
    /// - Offset -  This parameter check the for pagination required or not
    ///
    ///
    func getSearchGiphy(query: String, isOffset: Bool) {
        homeViewModel.fetchSearchedGiphy(searchText: query, isOffset: isOffset) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.refreshData()
                self.tableFooterView.activityIndicator.stopAnimating()
            }
        }
    }

    // MARK: - Actions

    /// Tableview cell delegate method is used to get button tap and save or delete favorite  Giphs.
    func cell(_ cell: GiphyTableViewCell, didTapButton button: UIButton) {
        var arrayURl: Gif!
        guard let indexPath = giphyTableView.indexPath(for: cell) else { return }
        
        if homeViewModel.isSearchBarActive {
            arrayURl = homeViewModel.searchedGifs[indexPath.row]
        } else {
            arrayURl = homeViewModel.gifs[indexPath.row]
        }
        
        button.isSelected = !button.isSelected
        if button.isSelected {
            let id = arrayURl.id
            if let fileToFind = savedFiles.first(where: { $0.id == id}) {
                homeViewModel.removeDataFromFileManager(filePath: fileToFind.url)
                savedFiles = homeViewModel.getGifFilesFromFileManager()
                refreshData()
            }
        } else {
            homeViewModel.saveGifInFileManager(url: arrayURl.images.fixedHeight.url, name: arrayURl.id){[self] result in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if result {
                        self.savedFiles = self.homeViewModel.filesData
                        self.refreshData()
                    }
                }
            }
        }
    }
}

///Tableview delegate and datasource methods to fetch and view the data in list
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homeViewModel.isSearchBarActive {
            if homeViewModel.searchedGifs.isEmpty {
                placeholderView.isHidden = false
            }
            else {
                placeholderView.isHidden = true
                return homeViewModel.searchedGifs.count
            }
        } else {
            if homeViewModel.gifs.isEmpty {
                placeholderView.isHidden = false
            }
            else {
                placeholderView.isHidden = true
                return homeViewModel.gifs.count
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? GiphyTableViewCell {
            cell.buttonFavorite.tag = indexPath.row
            cell.delegate = self
            let gifURl: URL
            let gifID: String
            if  homeViewModel.isSearchBarActive {
                let searchedGifs = homeViewModel.searchedGifs[indexPath.row]
                gifURl = searchedGifs.images.fixedHeight.url
                gifID = searchedGifs.id
            } else {
                let trendingGifsObj = homeViewModel.gifs[indexPath.row]
                gifURl = trendingGifsObj.images.fixedHeight.url
                gifID = trendingGifsObj.id
            }
            
            if savedFiles.first (where: { $0.id == gifID}) != nil {
                cell.buttonFavorite.setImage(UIImage(named:"Favorite"), for:.normal)
                cell.buttonFavorite.isSelected = false
            } else {
                cell.buttonFavorite.setImage(UIImage(named:"DeselectFav"), for:.normal)
                cell.buttonFavorite.isSelected = true
            }
            cell.gifImageView.image = UIImage(named:"Default")
            homeViewModel.getImageData(imageUrl: gifURl) { image, data in
                cell.gifImageView.image = image
                cell.gifImageView.contentMode = .scaleAspectFill
            }
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}

/// Search results uodate while typing
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchQuery = searchController.searchBar.text ?? ""
    }
}

/// This method is used to show activity indicator while using pagination.
/// Search giphy  and trending giphy are fetechd from pagination.
extension HomeViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let tableFooterViewHeight = giphyTableView.tableFooterView?.frame.height ?? 0
            if offsetY > contentHeight - scrollView.frame.height - tableFooterViewHeight {
                tableFooterView.activityIndicator.startAnimating()
                if homeViewModel.isSearchBarActive {
                    searchController.searchBar.resignFirstResponder()
                    let searchQuery = searchController.searchBar.searchTextField.text
                    getSearchGiphy(query: searchQuery!, isOffset: true)
                }
                else {
                    if searchController.isActive {
                        searchController.searchBar.resignFirstResponder()
                    }
                    getTrendingGiphy()
                }
            }
        }
    }
}
