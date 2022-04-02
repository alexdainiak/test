//
//  ViewController.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private enum Consts {
        static let backgroundColor = UIColor.darkGray
        static let title = "Photos"
        static let noDataTitle = "No data loaded"
    }
    
    private lazy var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInsetAdjustmentBehavior = .always
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = Consts.backgroundColor
        }
    }
    
    private var isLoading = false
    
    private var viewModel: MainScreenViewModelProtocol?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = MainScreenViewModel(networkClient: NetworkClient())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Consts.title
        binding()
        addedRefreshControl()
        viewModel?.loadPhotos()
    }
    
    // MARK: - Private methods
    
    private func binding() {
        viewModel?.updateView = { [weak self] in
            guard let self = self else { return }
            
            self.isLoading = false
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.collectionView.backgroundView = nil
                self.collectionView.reloadData()
            }
        }
        
        viewModel?.showAlert = { [weak self] message in
            guard let self = self else { return }
            
            self.isLoading = false
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.showAlert(message)
                self.setBackgroundText()
            }
        }
    }
    
    private func setBackgroundText() {
        let label = UILabel()
        label.text = Consts.noDataTitle
        label.textAlignment = .center
        label.numberOfLines = 0
        collectionView.backgroundView = label
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func addedRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refresh() {
        guard !isLoading else { return }
        isLoading = true
        viewModel?.loadPhotos()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
           let collectionViewSize = collectionView.frame.size.width - 3 * padding
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/3.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let photo = viewModel?.photos[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.setImage(on: photo.largeImageURL)
        cell.label.text = "Author: " //Author of photo
        return cell
    }
}

extension UIImageView {
    func setImage(on urlString: String) {
        let networkClient = NetworkClient()
        networkClient.fetchImage(on: urlString) {result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    print("fetched \(urlString)")
                    self.image = image
                }
            case .failure:
                self.image = nil
            }
        }
    }
}
