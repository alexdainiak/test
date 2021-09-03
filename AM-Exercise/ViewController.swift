//
//  ViewController.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInsetAdjustmentBehavior = .always
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    var handleDataCallback: ((Result<[Photo], NetworkClient.Error>) -> Void)!
    let networkClient = NetworkClient()

    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()


        handleDataCallback = { result in
            self.handleData(result: result)
        }

        networkClient.fetchImages(for: "ball", completion: handleDataCallback)
    }

    func handleData(result: Result<[Photo], NetworkClient.Error>) {
        switch result {
            case .success(let downLoadedPhotos):
                self.photos.append(contentsOf: downLoadedPhotos)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200/1.85)
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
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let photo = photos[indexPath.row]

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
