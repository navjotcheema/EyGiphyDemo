//
//  FavoritesViewController.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-15.
//

import UIKit

class FavoritesViewController: UIViewController,FavoriteGiphyCellDelegate {
    let placeholderView = PlaceholderView()
    var tabBarViewModel: TabBarViewModel = TabBarViewModel()
    var favViewModel: FavoriteViewModel = FavoriteViewModel()
    var homeViewModel = HomeViewModel()
    var savedGifsInFileManager: [File] = []
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        favViewModel.isGrid = true
        tabBarViewModel.loadTabBarItems()
        setUpSegementView(view: self.view)
        collectionView.collectionViewLayout = GridFlowLayOut()
        collectionView.setCollectionViewLayout(GridFlowLayOut(), animated: true)
        setUpPlaceholderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedGifsInFileManager = homeViewModel.getGifFilesFromFileManager()
        collectionView.reloadData()
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

    /// Setup segment view to display Grid and List  of items.
    func setUpSegementView(view:UIView) {
        let segmentedControl = UISegmentedControl(items: favViewModel.items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        // Set up constraints
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo:view.topAnchor,constant:60).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:10).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
    }
    
    /// TogleLayout is used to convert items in collection in Grid and List
    func toggleLayoutData() {
        if collectionView.collectionViewLayout is GridFlowLayOut {
            collectionView.setCollectionViewLayout(ListFlowLayout(), animated: true)
        } else {
            collectionView.setCollectionViewLayout(GridFlowLayOut(), animated: true)
        }
    }
    
    // MARK: - Actions

    /// Segment button action
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        toggleLayoutData()
    }
    
    /// Delegate  method of cell button to like favorite giphs.
    func favoriteCellButtonClicked(_ cell: CollectionViewCell, didTapButton button: UIButton) {
        let filePathUrl = savedGifsInFileManager[button.tag]
        homeViewModel.removeDataFromFileManager(filePath: filePathUrl.url)
        savedGifsInFileManager.removeAll()
        savedGifsInFileManager = homeViewModel.getGifFilesFromFileManager()
        collectionView.reloadData()
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if savedGifsInFileManager.isEmpty {
            placeholderView.isHidden = false
            return 0
        }
        else {
            placeholderView.isHidden = true
            return savedGifsInFileManager.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.buttonFavorite.tag = indexPath.row
        cell.delegate = self
        let savedFileObj = savedGifsInFileManager[indexPath.row]
        homeViewModel.getImageData(imageUrl: savedFileObj.url) { image, data in
            cell.imageView.image = image
            cell.imageView.contentMode = .scaleAspectFill
        }
        return cell
    }
}

