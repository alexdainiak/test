//
//  ViewController.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import UIKit

final class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private enum Consts {
        static let backgroundColor = UIColor.darkGray
        static let title = "Photos"
        static let noDataTitle = "No data loaded\nplease try to refresh"
        static let padding: CGFloat = 10
        static let semaphoreLimitValue = 16
        static let queueLabel = "com.exercise.AM-Exercise.operations.queue"
    }
    
    private lazy var refreshControl = UIRefreshControl()
    private let operationQueue = OperationQueue()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
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
        setOperations()
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
                if self.viewModel?.page ?? 1 == 1 {
                    self.setBackgroundText()
                }
            }
        }
    }
    
    private func setOperations() {
        operationQueue.name = Consts.queueLabel
        operationQueue.maxConcurrentOperationCount = 16
        operationQueue.qualityOfService = .background
    }
    
    private func setBackgroundText() {
        let label = UILabel()
        label.text = Consts.noDataTitle
        label.textAlignment = .center
        label.numberOfLines = 0
        collectionView.backgroundView = label
    }
    
    private func showAlert(_ message: String) {
        if viewModel?.page ?? 1 > 1 {
            viewModel?.page -= 1
        }
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
        viewModel?.page = 1
        viewModel?.loadPhotos()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width - 3 * Consts.padding
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/3.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Consts.padding, left: Consts.padding, bottom: Consts.padding, right: Consts.padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(Consts.padding)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(Consts.padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let photo = viewModel?.photos[indexPath.row],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell
        else {
            return UICollectionViewCell()
        }
        
        operationQueue.addOperation {
            cell.setImage(on: photo.previewURL ?? photo.largeImageURL)
        }
        
        cell.fillData(photo: photo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel?.photos.count ?? 0) - 10 {
            viewModel?.page += 1
            viewModel?.loadPhotos()
        }
    }
}
